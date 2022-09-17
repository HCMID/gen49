using EzXML
f = joinpath(pwd(), "texts", "editions", "Geneva49.xml")

teins = "http://www.tei-c.org/ns/1.0"

xp = "/ns:TEI/ns:text/ns:body/ns:div"
doc = readxml(f)

divs = findall(xp, root(doc),["ns"=> teins])

for d in divs
    psg = d["n"]            
    #@info(psg)
    tlist = findall("ns:table", d, ["ns"=> teins])
    for t in tlist
        if haskey(t, "n")
            tab = t["n"]  
            refbase = "$(psg).$(tab)"
            @info(refbase)
     
            for r in  findall("ns:row", t,  ["ns"=> teins])
                if haskey(r, "n")
                    row = r["n"]
                    @info("$(refbase).$(row)")
                else
                    @info("NO n attr for row in $(refbase)")
                end
                
                if haskey(r, "role")
                    role = r["role"]
                    @info("FORMAT ROLE $(role)")
                end
                cells = findall("ns:cell", r,  ["ns"=> teins])
                @info("$(length(cells)) cells")
      
            end
     
        else
            @info("No n attr for table in div $(psg)")
        end
    end
end