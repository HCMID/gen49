using EzXML
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

divs = findall(xp, root(doc),["ns"=> teins])
for d in divs
    psg = d["n"]            
    tlist = findall("ns:table", d, ["ns"=> teins])
    for t in tlist
        if haskey(t, "n")
            tab = t["n"]  
            refbase = "$(psg).$(tab)"
            @info(refbase)
     
            for r in  findall("ns:row", t,  ["ns"=> teins])
                if haskey(r, "n")
                    row = r["n"]
                    ref = "$(refbase).$(row)"
                    println(ref, "|", format_row(r))

                else
                    @warn("NO n attr for row in $(refbase)")
                end
            end
        else
            @warn("No n attr for table in div $(psg)")
        end
    end
end