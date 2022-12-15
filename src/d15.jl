# An IntervalSet type and a bunch of methods
struct IntervalSet{T}
    intervals::Vector{Vector{T}}
end
function IntervalSet(T::Type)
    IntervalSet{T}(Vector{Vector{T}}())
end
function Base.push!(s::IntervalSet, val)
    overlaps = Int[]
    after = [0]
    for (i,interval) in enumerate(s.intervals[1:end])
        if (val[2] >= interval[1]) & (val[1] <= interval[2])
            push!(overlaps,i)
        elseif val[1] > interval[2]
            push!(after,i)
        end
    end
    if isempty(overlaps)
        insert!(s.intervals,maximum(after)+1,val)
    else
        s.intervals[overlaps[1]] .= [
            min(val[1],[interval[1] for interval in s.intervals[overlaps]]...),
            max(val[2],[interval[2] for interval in s.intervals[overlaps]]...)
        ]
        splice!(s.intervals,overlaps[2:end])
    end
    s
end
function Base.size(s::IntervalSet)
    res = 1
    for interval in s.intervals
        res += diff(interval)[1]
    end
    return(res)
end

function intervaldiff(v,t)
    res = IntervalSet(Int)
    if t[1] > v[1]
        push!(res,[v[1],t[1]-1])
    end
    if t[end] < v[end]
        push!(res,[t[end]+1,v[end]])
    end
    return(res)
end



struct Sensor
    position::Vector{Int}
    beacon::Vector{Int}
    dist::Int
    yspan::UnitRange{Int64}
    xspan::UnitRange{Int64}
end


function loadinput(path)
    lines = open(path) do file
        readlines(file)
    end
    sensors = Sensor[]
    for line in lines
        matches = match(r"x\=(\-?\d+).*y\=(\-?\d+).*x\=(\-?\d+).*y\=(\-?\d+)",line)
        coords = [parse(Int,matches[i]) for i in 1:4]
        dist = sum(abs.(coords[1:2] .- coords[3:4]))
        push!(sensors,Sensor(
            coords[1:2],
            coords[3:4],
            dist,
            (coords[2]-dist):(coords[2]+dist),
            (coords[1]-dist):(coords[1]+dist)
        ))
    end
    return(sensors)
end

function rowcoverage(y,sensors)
    covered = IntervalSet(Int)
    beacons = Set{Vector{Int}}()
    for sensor in sensors
        if y ∉ sensor.yspan
            continue
        end
        ydiff = abs(sensor.position[2] - y)
        xdist = sensor.dist - ydiff
        xspan = [(sensor.position[1] - xdist),(sensor.position[1] + xdist)]
        push!(covered,xspan)
        if sensor.beacon[2] == y
            push!(beacons,sensor.beacon)
        end
    end
    return(covered,beacons)
end
function unscanned(sensors::Vector{Sensor},xrange::UnitRange{Int},yrange::UnitRange{Int},printat=nothing)
    res = Vector{Vector{Int}}()
    for y in yrange
        if !isnothing(printat) & ((y % printat)==0)
            println(y)
        end
        covered = rowcoverage(y,sensors)[1]
        intervals = []
        for interval in covered.intervals 
            push!(intervals,intervaldiff(xrange,interval).intervals...)
        end
        if !isempty(intervals)
            sort!(intervals)
            push!(res,[intervals[1][2],y])
        end
    end
    return(res)
end


sensors = loadinput("data/d15.txt")

part1 = rowcoverage(2000000,sensors)
println("Part 1: $(size(part1[1])-length(part1[2]))")

part2 = unscanned(sensors,0:4000000,0:4000000,500000)[1]
println("Part 2: $(part2[1]*4000000 + part2[2])")

