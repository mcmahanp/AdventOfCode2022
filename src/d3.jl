# Part 1
function bothcompartments(s)
    n = length(s)
    firsthalf = Set(s[1:Int(n/2)])
    for c in s[Int(n/2)+1:end]
        if c in firsthalf
            return c 
        end
    end
end

function charval(c)
    if islowercase(c)
        val = Int(c) - 96
    elseif isuppercase(c)
        val = Int(c) - 38
    else 
        val = nothing
    end
    return(val)
end

valcalc(s) = charval(bothcompartments(s))

open("data/d3.txt") do file
    total = 0
    for ln in eachline(file)
        total += valcalc(ln)
    end
    println("Part 1: $total")
end


# Part 2
function allthree(lines)
    sets = map(Set,lines)
    pop!(intersect(sets...))
end

open("data/d3.txt") do file
    total = 0
    lines = String[]
    for ln in eachline(file)
        push!(lines,ln)
        if length(lines) == 3
            at = allthree(lines)
            #print(lines)
            total += charval(at)
            #println("$at: $(charval(at)) ($total)")
            lines = String[]
        end
    end
    println("Part 2: $total")
end


