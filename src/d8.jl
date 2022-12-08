# reads path into an array
function readdatamat(path,T=Any)
    # no checks!
    rows = open(path) do file
        return readlines(file)
    end
    n = length(rows)
    m = length(rows[1])
    res = Array{T}(undef,n,m)
    for i in 1:n
        res[i,:] = map(x->parse(T,String(x)),split(rows[i],""))
    end
    return(res)
end

# apply a function f to rhe rows and columns
# of a matrix m. f is assumed to return an
# n x 2 array when given a length-n vector
# (in this case, the result for the vector coming
# from the left and from the right)
function sweepdirections(m,f)
    res = Array{typeof(m[1,1])}(undef,size(m)...,4)
    for i in 1:size(m)[1]
        res[i,:,1:2] = f(m[i,:])
        res[:,i,3:4] = f(m[:,i])
    end
    return(res)
end

# a function to pass to sweepdirections
# that finds the minimum covered hight from
# a direction for each position in the vector
function mincover(v)
    res = zeros(typeof(v[1]),length(v),2)
    res[1,1] = -1
    res[2,1] = v[1]
    res[end,2] = -1
    res[end-1,2] = v[end]
    for i in 3:(length(v))
        # left
        res[i,1] = max(res[i-1,1],v[i-1])
        # right
        res[end+1-i,2] = max(res[end+2-i,2],v[end+2-i])
    end
    return(res)
end

# a function to pass to sweepdirections
# that finds the view score component from
# each direction for each point in the vector
function singleview(v)
    distances = zeros(typeof(v[1]),10,2)
    res = zeros(typeof(v[1]),length(v),2)
    for i in 1:length(v)
        #left
        res[i,1] = distances[v[i]+1,1]
        distances[:,1] .+= 1
        distances[1:(v[i]+1),1] .= 1
        # right
        res[end+1-i,2] = distances[v[end+1-i]+1,2]
        distances[:,2] .+= 1
        distances[1:(v[end+1-i]+1),2] .= 1
    end
    return(res)
end

# now parts 1 and 2 just need to sweep their respective
# functions over the array and reduce

function part1(tree_heights)
    directional = sweepdirections(tree_heights,mincover)
    mindirectional = reshape(minimum(directional,dims=3),99,99)
    hiddenmap = tree_heights .≤ mindirectional
    println("Part 1: $(sum(hiddenmap .< 1))")
end

function part2(tree_heights)
    directional = sweepdirections(tree_heights,singleview)
    scenicscore = prod(directional,dims=3)
    println("Part 2: $(maximum(scenicscore))")
end


tree_heights = readdatamat("data/d8.txt",Int)
part1(tree_heights)
part2(tree_heights)