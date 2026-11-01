# check_positive_20_100.jl
# Standalone version of the input-validation while-loop example from Week 4
# (section 2 of week04-examples.jl). Keeps asking until the number falls in the
# accepted range. With <= and >=, exactly 20 and 100 are rejected; use < and >
# to accept them too.
#
# Run from a terminal:
#   julia check_positive_20_100.jl

let
    print("Please enter a positive number 20..100: ")
    number = parse(Int, readline())
    while number <= 20 || number >= 100
        print("A positive number 20..100, try again: ")
        number = parse(Int, readline())
    end
    println("Your positive number is ", number)
end
