using Counters

function loaddata(path="data/d7.txt")
    commands = open(path) do file
        return readlines(file)
    end
    return commands
end

function getsizes(commands)
    directory_sizes = Dict{Vector{String},Int}()
    current_path = String[]
    for line in commands
        line_terms = split(line)
        if (line_terms[1] == "\$") & (line_terms[2] == "cd")
            if line_terms[3] == ".."
                pop!(current_path)
            else
                push!(current_path,line_terms[3])
            end
        elseif !isnothing(match(r"\d+",line_terms[1]))
            file_size = parse(Int,line_terms[1])
            for path_depth in 1:length(current_path)
                partial_path = current_path[1:path_depth]
                directory_sizes[partial_path] = get(directory_sizes,partial_path,0)+file_size
            end
        end
    end
    return(directory_sizes)
end

function part1(directory_sizes)
    println("Part 1: $(sum([v for v in values(directory_sizes) if v <= 100000]))")
end

function part2(directory_sizes)
    candidate_size = directory_sizes[["/"]]
    needed = 30000000 - 70000000 + candidate_size
    for size in values(directory_sizes)
        if (size < candidate_size) & (size >= needed)
            candidate_size = size 
        end
    end
    println("Part 2: $candidate_size")
end

commands = loaddata()
directory_sizes = getsizes(commands)
part1(directory_sizes)
part2(directory_sizes)

