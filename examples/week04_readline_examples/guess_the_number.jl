# guess_the_number.jl
# Standalone version of the guess-the-number while-loop example from Week 4
# (section 2 of week04-examples.jl). The computer picks a number; the loop
# keeps reading guesses and gives a hint until the guess is right.
#
# Run from a terminal:
#   julia guess_the_number.jl

let
    number = rand(1:16)
    print("please guess my number between 1 and 16 ")
    flush(stdout)
    guess = parse(Int, readline())
    while guess != number
        if number > guess
            print("My number is bigger, please try again ")
        else
            print("My number is smaller, please try again ")
        end
        flush(stdout)
        guess = parse(Int, readline())
    end
    println("You guessed it! The number is ", number)
end
