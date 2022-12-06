# 1 rock
# 2 paper
# 3 scissors
function rpsscore(theirs,mine)
    if theirs==mine
        res = 3
    elseif theirs==1
        if mine==2
            res = 6
        else
            res = 0
        end
    elseif theirs==2
        if mine==3
            res = 6
        else
            res = 0
        end
    elseif theirs==3
        if mine==1
            res = 6
        else
            res = 0
        end
    else
        print("$theirs is not a valid play")
    end
    return mine + res
end


# Part 1
playmap = Dict(
    "A" => 1,
    "B" => 2,
    "C" => 3,
    "X" => 1,
    "Y" => 2,
    "Z" => 3
)
open("data/d2.txt") do file
    total = 0
    for ln in eachline(file)
        plays = split(ln," ")
        total += rpsscore(playmap[plays[1]], playmap[plays[2]])
    end
    println("Part 1: $total")
end


# Part 2
playmap = Dict(
    "A" => 1,
    "B" => 2,
    "C" => 3,
    "A X" => 3,
    "A Y" => 1,
    "A Z" => 2,
    "B X" => 1,
    "B Y" => 2,
    "B Z" => 3,
    "C X" => 2,
    "C Y" => 3,
    "C Z" => 1
)
open("data/d2.txt") do file
    total = 0
    for ln in eachline(file)
        plays = split(ln," ")
        total += rpsscore(playmap[plays[1]], playmap[ln])
    end
    println("Part 2: $total")
end
