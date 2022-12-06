
# load data
function loaddata()
    crates = Dict()
    instructions = String[]
    open("data/d5.txt") do file
        # first grab the crate positions
        for ln in eachline(file)
            if length(strip(ln))==0
                break
            end
            starts = findall('[',ln)
            cratenums = Int.((starts .- 1)./4 .+ 1)
            vals = ln[starts .+ 1]
            for (k,v) in zip(cratenums,vals)
                if !haskey(crates,k)
                    crates[k] = []
                end
                pushfirst!(crates[k],v)
            end
        end
        # and the rest of the lines should go into instructions
        push!(instructions,eachline(file)...)
    end
    return (crates,instructions)
end


# Part 1
function part1()
    crates,instructions = loaddata()

    # move the crates
    for s in instructions
        (n,from,to) = map(x -> parse(Int,x),split(s)[[2,4,6]])
        for i in 1:n
            push!(crates[to],pop!(crates[from]))
        end
    end

    print("Part 1: ")
    for i in 1:maximum(keys(crates))
        print(last(crates[i]))
    end
    print('\n')
end

# Part 2
function part2()
    crates,instructions = loaddata()

    # move the crates
    for s in instructions
        (n,from,to) = map(x -> parse(Int,x),split(s)[[2,4,6]])
        #print(n,from,to)
        #print('\n')
        h = length(crates[from])
        cratestack = splice!(crates[from],h-n+1:h)
        push!(crates[to],cratestack...)
    end

    print("Part 2: ")
    for i in 1:maximum(keys(crates))
        print(last(crates[i]))
    end
    print('\n')
end

part1()
part2()

