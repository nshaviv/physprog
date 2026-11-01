# class_average_sentinel.jl
# Standalone version of the sentinel while-loop example from Week 4 (section 2
# of week04-examples.jl). Reads grades until -1 is entered, then prints the
# class average.
#
# Run from a terminal:
#   julia class_average_sentinel.jl
#
# A standalone script reads standard input cleanly; running readline examples
# cell by cell in the editor REPL needs an extra Enter.

let
    sum_grades = 0      # total of the grades
    n_grades = 0        # how many grades were entered
    print("Enter grade (-1 to stop): ")
    grade = parse(Int, readline())
    while grade != -1
        sum_grades += grade
        n_grades += 1
        print("Enter grade (-1 to stop): ")
        grade = parse(Int, readline())
    end
    if n_grades != 0
        avg = sum_grades / n_grades
        println("Class average is ", round(avg; digits = 2),
                "; number of grades is ", n_grades)
    else
        println("No grades were entered")
    end
end
