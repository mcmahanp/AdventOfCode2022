function loadinstructions(path)
    directionmap = Dict(
        "U" => [ 1, 0],
        "D" => [-1, 0],
        "R" => [ 0, 1],
        "L" => [ 0,-1]
    )
    instructions = open(path) do file
        return readlines(file)
    end
    res = Vector{Int}[]
    for (direction, timesstr) in split.(instructions)
         times = parse(Int,timesstr)
         push!(res, repeat([directionmap[direction]],times)...)
    end
    return(res)
end

# decide the move for a subsequent knot
function followmove(knot1,knot2)
    position_diff = knot1 - knot2
    if maximum(abs.(position_diff)) <= 1
        return([0,0])
    end
    return(sign.(position_diff))
end

# propogate positions from top to bottom
function updatepositions!(positions)
    for i in 2:size(positions)[1]
        positions[i,:] .+= followmove(positions[i-1,:],positions[i,:])
    end
end

function tracktail(moves,ropelength)
    positions = zeros(Int,ropelength,2)
    visited = Set([copy(positions[end,:])])
    for move in moves
        positions[1,:] .+= move
        updatepositions!(positions)
        push!(visited,copy(positions[end,:]))
    end
    return(length(visited))
end

moves = loadinstructions("data/d9.txt")
println("Part 1: $(tracktail(moves,2))")
println("Part 2: $(tracktail(moves,10))")