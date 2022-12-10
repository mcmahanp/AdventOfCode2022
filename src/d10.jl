# a dict of CPU ops of three arguments:
# t (cycle), x (vector of register states), v (input value)
cpuops! = Dict(
    "addx" => (t,x,v) -> (x[t.+1] = x[t]; x[t.+2] = x[t].+v; t .+= 2),
    "noop" => (t,x,v) -> (x[t.+1] = x[t]; t .+= 1)
)
oplengths = Dict("addx" => 2, "noop" => 1)

function registerstates(path)
    instructions = open(path) do file
        return readlines(file)
    end
    # total cycles (yuck)
    n = sum([oplengths[op[1]] for op in split.(instructions)]) + 1
    #initialize state vector
    res = zeros(Int,n)
    res[1] = 1
    t = [1]
    for inst in split.(instructions)
        v = if length(inst)>1 parse(Int,inst[2]) else 0 end
        cpuops![inst[1]](t,res,v)
    end
    return(res)
end

function part1(states)
    strength = sum([(t * x) for (t,x) in zip(20:40:length(states),states[20:40:end])])
    println("Part 1: $strength")
end

function part2(states)
    statearray = transpose(reshape(states[1:240],(40,6),)) 
    positions = transpose(reshape(0:239,(40,6))) .% 40
    lit = (statearray .>= (positions .- 1)) .& (statearray .<= (positions .+ 1))
    println("Part 2:")
    for i in 1:size(lit)[1]
        for j in 1:size(lit)[2]
            print(if lit[i,j] "█" else " " end)
        end
        print('\n')
    end
end


states = registerstates("data/d10.txt")
part1(states)
part2(states)
