# harmonic_series_time.jl
# Standalone version of the harmonic-series timing while-loop example from
# Week 4 (section 2 of week04-examples.jl). Counts how many terms of
# 1 + 1/2 + 1/3 + ... are needed before the sum exceeds the given limit, and
# times the loop. A maximum number of terms guards the loop: if the sum has not
# reached the limit by then, we break and report that the limit was too large.
#
# Run from a terminal:
#   julia harmonic_series_time.jl
#
# For limit 10 the answer is 12367 terms (instant). For limit 20 it would be
# about 272,400,600 terms, which is more than the cap, so the loop stops at
# 100,000,000 terms and prints that the limit was too large.

let
    print("Enter positive limit: ")
    flush(stdout)
    limit = parse(Float64, readline())

    max_terms = 100_000_000   # safety cap on the number of terms
    t1 = time_ns()
    series_sum = 0.0
    n = 0
    while series_sum <= limit
        n += 1
        series_sum += 1.0 / n
        if n >= max_terms
            println("Limit ", limit, " too large: stopped after ", n,
                    " terms without exceeding it.")
            break
        end
    end
    t2 = time_ns()

    println("Number of terms needed: ", n)
    println("Elapsed seconds: ", round((t2 - t1) / 1.0e9; digits = 3))
end
