
# Part 1
open("data/d1.txt") do file
    this_total = 0
    best_total = 0
    for ln in eachline(file)
        if length(ln) == 0
            this_total = 0
            continue
        end
        this_total += parse(Int,ln)
        if this_total > best_total
            best_total = this_total
        end
    end
    println("Part 1: $(best_total)")
end

# Part 2
elves = Int[]
open("data/d1.txt") do file
    this_total = 0
    for ln in eachline(file)
        if length(ln) == 0
            push!(elves, this_total)
            this_total = 0
            continue
        end
        this_total += parse(Int,ln)
    end
end
sort!(elves)
println("Part 2: $(sum(elves[end-2:end]))")



