# Part 1

open("data/d4.txt") do file
    total = 0
    for ln in eachline(file)
        e1,e2 = split(ln,',')
        v1 = map(x -> parse(Int,x), split(e1,"-"))
        v2 = map(x -> parse(Int,x), split(e2,"-"))
        if ((v1[1] >= v2[1]) & (v1[2] <= v2[2])) | ((v1[1] <= v2[1]) & (v1[2] >= v2[2]))
            #println("$e1 -- $e2")
            #println("$(v1[1] >= v2[1]) $(v1[2] <= v2[2]) $(v1[1] <= v2[1]) $(v1[2] >= v2[2])")
            #println("$(v1[1] >= v2[1] & v1[2] <= v2[2]) $(v1[1] <= v2[1] & v1[2] >= v2[2])")
            total += 1 
        end
    end
    println("Part 1: $total")
end


# Part 2

open("data/d4.txt") do file
    total = 0
    for ln in eachline(file)
        e1,e2 = split(ln,',')
        v1 = map(x -> parse(Int,x), split(e1,"-"))
        v2 = map(x -> parse(Int,x), split(e2,"-"))
        if ((v1[1] <= v2[1]) & (v1[2] >= v2[1])) | ((v2[1] <= v1[1]) & (v2[2] >= v1[1]))
            total += 1 
        end
    end
    println("Part 2: $total")
end
