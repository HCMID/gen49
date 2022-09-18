using EzXML
using CitableBase, CitableText, CitableCorpus

f = joinpath(pwd(), "texts", "editions", "Geneva49.xml")
teins = "http://www.tei-c.org/ns/1.0"
xp = "/ns:TEI/ns:text/ns:body/ns:div"
doc = readxml(f)


function format_row(row)
    if haskey(row, "role")
        role = row["role"]
        @info("FORMAT ROLE $(role)")
    end
    cells = findall("ns:cell", row,  ["ns"=> teins])
    #@info("$(psg): $(length(cells)) cells")
    rowtext = []
    for c in cells
        stripped = replace(c.content, "\n" => " " )
        push!(rowtext,  replace(stripped, r"[ ]+" => " ") *  " | ") 
    end
    join(rowtext,"") * " |"
end

function j_divs(divlist, urnbase)
    cex = []
    for d in divlist
        psg = d["n"]            
        tlist = findall("ns:table", d, ["ns"=> teins])
        for t in tlist
            if haskey(t, "n")
                tab = t["n"]  
                refbase = "$(psg).$(tab)"
                urn = "$(urnbase)$(refbase)"
        
                for r in  findall("ns:row", t,  ["ns"=> teins])
                    @info("ROW")
                    if haskey(r, "n")
                        row = r["n"]
                        ref = "$(urn).$(row)"
                        push!(cex, string(ref, "|", format_row(r)))
                        #@info("Pushed ", string(ref, "|", format_row(r)))

                    else
                        @warn("NO n attr for row in $(refbase)")
                    end
                end
            else
                @warn("No n attr for table in div $(psg)")
            end
        end
    end
    join(cex,"\n")
end

gen49 = "urn:cts:latinLit:stoa0162.stoa005.gen49:"
divs = findall(xp, root(doc),["ns"=> teins])
cexall  = j_divs(divs, gen49)


psgs = []
for ln in split(cexall, "\n")
    cols = split(ln, "|")
    urn = CtsUrn(cols[1])
    txt = "|" * join(cols[2:end], " | ") * " |"
    push!(psgs, CitablePassage(urn,txt))
end