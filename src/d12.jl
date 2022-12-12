function loadmap(path)
    lines = open(path) do file
        lines = readlines(file)
    end
    n = length(lines)
    m = length(lines[1])
    heights = Array{Int}(undef,n,m)
    for i in 1:n
        heights[i,:] = Int.([c for c in lines[i]])
    end
    # deal with S and E
    startpos = findall(heights .== Int('S'))[1]
    heights[startpos] = Int('a')
    endpos = findall(heights .== Int('E'))[1]
    heights[endpos] = Int('z')
    return(heights,startpos,endpos)
end

function passability(heights)
    passable = zeros(Bool,size(heights)...,4)
    # N E S W
    passable[2:end,:,1] = ((heights[1:end-1,:] - heights[2:end,:]) .< 2) # North
    passable[:,1:end-1,2] = ((heights[:,2:end] - heights[:,1:end-1]) .< 2) # East
    passable[1:end-1,:,3] = ((heights[2:end,:] - heights[1:end-1,:]) .< 2) # South
    passable[:,2:end,4] = ((heights[:,1:end-1] - heights[:,2:end]) .< 2) # West
    return(passable)
end

# Dijkstra's algorithm (could use A* here, but going to keep it general)
function shortestpathlength(passable,startpos,endpos)
    cardinal = [
        CartesianIndex(-1,0),CartesianIndex(0,1),
        CartesianIndex(1,0),CartesianIndex(0,-1)]
    # using a dict for convenience, but this could be made more efficient
    tentative = Dict(i => Inf for i in CartesianIndices(passable[:,:,1]))
    tentative[startpos] = 0
    current = startpos
    while current != endpos
        d = tentative[current]
        for (i,direction) in enumerate(passable[current,:])
            if direction <= 0
                continue
            end
            nextpos = current + cardinal[i]
            if haskey(tentative,nextpos)
                tentative[nextpos] = min(
                    tentative[current + cardinal[i]],
                    d+direction
                )
            end
        end
        pop!(tentative,current)
        current = argmin(tentative)
    end
    return(tentative[endpos])
end

# For part 2:
# I could flip the problem around, use Dijkstra's to find the shortest
# path from E to all other nodes, and then find nearest `a` in there,
# but instead I'll just try every `a` with this same algorithm.
# it's slow but not too slow.
function closeststart(passable,endpos)
    res = Inf
    for startpos in findall(heights .== Int('a'))
        res = min(res,shortestpathlength(passable,startpos,endpos))
    end
    return(res)
end


(heights,startpos,endpos) = loadmap("data/d12.txt")
passable = passability(heights)
println("Part 1: $(shortestpathlength(passable,startpos,endpos))")
println("Part 2: $(closeststart(passable,endpos))")



