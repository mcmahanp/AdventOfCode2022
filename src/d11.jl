# fine, I guess I'll define Monkey type
struct Monkey
    inventory::Vector{Int}
    operation::Function
    test::Function
end

function loadinput(path,reduction=3)
    lines = open(path) do file
        lines = readlines(file)
    end
    monkeys = Monkey[]
    slines = split.(lines,":")
    for i in 1:7:length(lines)
        # inventory
        inventory = parse.(Int,split(slines[i+1][2],","))
        # operation
        opstring = "old -> div(" * slines[i+2][2][7:end] * ",$(reduction)) % 9699690"
        operation = eval(Meta.parse(opstring))
        # test
        d,t,f = [parse(Int,l[end]) for l in split.(lines[i+3:i+5])]
        test(v) = (v % d) == 0 ? t+1 : f+1
        push!(monkeys,Monkey(inventory,operation,test))
    end
    return(monkeys)
end

function monkeybusiness(monkeys,rounds)
    inspected = zeros(UInt,length(monkeys))
    for round in 1:rounds
        for (monkeynum, monkey) in enumerate(monkeys)
            while length(monkey.inventory)>0
                inspected[monkeynum] += 1
                v = monkey.operation(popfirst!(monkey.inventory))
                push!(monkeys[monkey.test(v)].inventory,v)
            end
        end
    end
    sort!(inspected)
    return(prod(inspected[end-1:end]))
end

monkeys = loadinput("data/d11.txt",3)
println("Part 1: $(monkeybusiness(monkeys,20))")
monkeys = loadinput("data/d11.txt",1)
println("Part 2: $(monkeybusiness(monkeys,10000))")

