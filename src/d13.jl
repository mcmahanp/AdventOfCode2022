# I *could* just `using JSON`, but let's 
# see how I do at writing a parser? :D
function parseintlist(s,i=1)
    if s[i] != '['
        return nothing
    end
    res = []
    digits = ""
    i += 1
    while s[i] != ']'
        if s[i] == '['
            (val,i) = parseintlist(s,i)
            push!(res,val)
        elseif isdigit(s[i])
            digits *= s[i]
        elseif length(digits) > 0
            push!(res,parse(Int,digits))
            digits = ""
        end
        i += 1
    end
    if length(digits) > 0
        push!(res,parse(Int,digits))
    end
    return(res,i)
end

function loadinput(path)
    lines = open(path) do file
        lines = readlines(file)
    end
    return[parseintlist(l)[1] for l in lines if !isempty(l)]
end

# let's make our own comparator
sigcomp(x::Int,y::Int) = cmp(x,y)
sigcomp(x::Vector{Any},y::Int) = sigcomp(x,Any[y])
sigcomp(x::Int,y::Vector{Any}) = sigcomp(Any[x],y)
function sigcomp(x::Vector{Any},y::Vector{Any})
    #println("x,y:\n  $(replace(repr(x),"Any" => ""))\n  $(replace(repr(y),"Any" => ""))")
    for i in 1:max(length(x),length(y))
        if i > length(x)
            return(-1)
        end
        if i > length(y)
            return(1)
        end
        c = sigcomp(x[i],y[i])
        if c != 0
            return(c)
        end
    end
    return(0)
end

# load data
path = "data/d13.txt"
inputlines = loadinput(path)

# part 1
inputpairs = zip(inputlines[1:2:end],inputlines[2:2:end])
comparisons = [sigcomp(x,y) for (x,y) in inputpairs]
println("Part 1: $(sum(findall(comparisons.<0)))") 

# part 2
push!(inputlines,Any[Any[2]],Any[Any[6]])
sort!(inputlines,lt=(x,y) -> sigcomp(x,y)<0)
part2 = prod([i for (i,v) in enumerate(inputlines) if v ∈ (Any[Any[2]],Any[Any[6]])])
println("Part 2: $part2") 

