function loadinput(path)
    lines = open(path) do file
        lines = readlines(file)
    end

    xrange = [500,500]
    yrange = [0,0]

    paths = []
    for stringpath in [split.(p,",") for p in split.(lines," -> ")]
        path = Vector{Int}[]
        for edge in stringpath
            push!(path,parse.(Int,edge) .+ [0,1])
            xrange[1] = min(xrange[1],path[end][1])
            xrange[2] = max(xrange[2],path[end][1])
            yrange[1] = min(yrange[1],path[end][2])
            yrange[2] = max(yrange[2],path[end][2])
        end
        push!(paths,path)
    end

    xoffset = 0
    abyss = yrange[2] + 1
    n = diff(yrange)[1]+2
    m = 1000
    map = zeros(Int,(n,m))
    for path in paths
        for i in 1:(length(path)-1)
            if path[i][1] == path[i+1][1]
                x = path[i][1] - xoffset
                y = range(sort([path[i][2],path[i+1][2]])...)
            else
                x = range(sort([path[i][1] - xoffset,path[i+1][1] - xoffset])...)
                y = path[i][2]
            end
            map[y,x] .= 2
        end
    end
    return(map,500-xoffset)
end

function sandstep!(map,pos,fillcount)
    i,j = pos
    if map[i+1,j] == 0
        pos .+= [1,0]
    elseif map[i+1,j-1] == 0
        pos .+= [1,-1]
    elseif map[i+1,j+1] == 0
        pos .+= [1,1]
    else
        map[pos...] = 1
        fillcount .+= 1
        (pos[1] == 1) ? (return(-1)) : (return(1))
    end
    if (pos[1] == size(map)[1])
        return(0)
    end
end

function sandfall!(map,pos,fillcount)
    while true
        res = sandstep!(map,pos,fillcount)
        if !isnothing(res)
            return(res)
        end
    end
end

function part1(map,source)
    fillcount = [0]
    res = 1
    while res > 0
        pos = [1,source]
        res = sandfall!(map,pos,fillcount)
    end
    return(fillcount[1])
end
function part2(map,source)
    map[end,:] .= 2
    fillcount = [0]
    res = 1
    while res > 0
        pos = [1,source]
        res = sandfall!(map,pos,fillcount)
    end
    return(sum(map .== 1))
end




map, source = loadinput("data/d14.txt")
println("Part 1: $(part1(map,source))")
println("Part 2: $(part2(map,source))")
