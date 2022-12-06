function loaddata(path="data/d6.txt")
    s = open(path) do file
        return readline(file)
    end
    return s 
end

function findmessage(signal,n=4)
    for i in 1:(length(signal)-(n-1))
        if length(Set(signal[i:i+(n-1)])) >= n
            return i+(n-1)
        end
    end
    return nothing
end

println("Part 1: $(findmessage(signal,4))")
println("Part 2: $(findmessage(signal,14))")