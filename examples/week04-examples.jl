# week04-examples.jl
# Chapter 4 (Week 4) — matrices, nested loops, symmetry checks, and rotations in one runnable file.

# --- 1. Matrix literals and shape ----------------------------------------------

A = [1 2 3; 4 5 6]      # a 2-by-3 matrix: 2 rows, 3 columns
println(A)
println(size(A))         # (2, 3)
println(size(A, 1))      # 2   (number of rows)
println(size(A, 2))      # 3   (number of columns)
println(length(A))       # 6   (total number of entries)

# Two-dimensional indexing: row first, then column.
println(A[2, 3])         # 6
println(A[1, :])         # [1 2 3]   the first row (a 1-by-3 matrix)
println(A[:, 2])         # [2, 5]    the second column (a vector)

# --- 2. while loops: repeat until a condition turns false ------------------------

# A while loop repeats for as long as its condition is true. Unlike a for loop,
# it has no built-in counter: you must change the condition inside the body, or
# the loop never ends.
# 
# Standalone, terminal-friendly copies of the
# four readline examples below are in the week04_readline_examples/ subdirectory.

# First, a tiny loop without any input, to see the mechanics.
let
    n = 0
    while n < 5
        n += 1
        println(n)
    end
end                     # prints 1, 2, 3, 4, 5

# Example A — sentinel loop ("class average"): keep reading grades until the
# user enters -1. The value -1 is a sentinel: it marks the end of the input,
# not a real grade.
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
# can run include("week04_readline_examples/class_average_sentinel.jl") in the repl.

# Example B — input validation (check_positive_20_100): keep asking until the
# input falls in the accepted range. The loop condition is the negation of what
# we want: it continues while the input is bad. (With <= and >=, exactly 20 and
# 100 are rejected; use < and > to accept them too.)
let
    print("Please enter a positive number 20..100: ")
    flush(stdout) # Make sure the prompt appears before waiting for input.
    number = parse(Int, readline())
    while number <= 20 || number >= 100
        print("A positive number 20..100, try again: ")
        number = parse(Int, readline())
    end
    println("Your positive number is ", number)
end
# can run include("week04_readline_examples/check_positive_20_100.jl") in the repl.

# Example C — guess the number (Guess_the_number): the computer picks a number;
# the loop keeps reading guesses and gives a hint until the guess is right. The
# loop may run zero times (first guess correct) or many times.
let
    number = rand(1:16)
    print("please guess my number between 1 and 16 ")
    flush(stdout) # 
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
# can run include("week04_readline_examples/guess_the_number.jl") in the repl.

# Example D — timing a while loop (while_series_example_time): the harmonic
# series 1 + 1/2 + 1/3 + ... grows very slowly, roughly like ln(n), so reaching
# a modest sum needs many terms. We add a maximum number of terms as a safety
# cap: if the sum has not reached the limit by then, we break and report that
# the limit was too large.
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
    # For limit 10: 12367 terms (instant).
    # For limit 20: about 272,400,600 terms — more than the cap, so the loop
    # stops at 100,000,000 terms and prints that the limit was too large.
end
# can run include("week04_readline_examples/harmonic_series_time.jl") in the repl.

# --- 3. Matrix-vector and matrix-matrix products --------------------------------

M = [1 2; 3 4]
v = [5, 6]
println(M * v)           # [17, 39]   matrix * vector: linear combination of columns
println(M .* M)          # [1 4; 9 16]  elementwise multiplication (dotted)
println(M * M)           # [7 10; 15 22]  true matrix product

# --- 4. Nested loops: a multiplication table ------------------------------------

# A double loop fills a 10-by-10 table with products i * j.
let
    table = zeros(Int, 10, 10)
    for i in 1:10
        for j in 1:10
            table[i, j] = i * j
        end
    end
    println(table[3, 4])       # 12
    println(table[10, 10])     # 100
    println(table[3, 1:5])     # [3, 6, 9, 12, 15]   (row 3)
    println(table)
end

# Bonus: How to print the table nicely. The first version is just a raw println, which is not very readable:
# Yuck!
# println(table)     

# Nicer version using PrettyTables.jl, but not required for the course.
using Pkg
Pkg.add("PrettyTables")   # install PrettyTables if not already installed
using PrettyTables
let
    global table = zeros(Int, 10, 10)
    for i in 1:10
        for j in 1:10
            table[i, j] = i * j
        end
    end
    pretty_table(table)
end


# --- 5. Nested loops: matrix multiplication -------------------------------------

# The entry (i, j) of A * B is the dot product of row i of A with column j of B:
#   C[i, j] = A[i, 1] B[1, j] + A[i, 2] B[2, j] + ... + A[i, k] B[k, j]
# So one double loop visits every output entry, and an inner loop accumulates
# the sum over k. That is the "triple loop" recipe.
let
    A = [1.0 2.0 3.0; 
         4.0 5.0 6.0]   # 2-by-3
    B = [1.0 0.0 2.0 1.0; 
         0.0 1.0 1.0 0.0; 
         2.0 1.0 0.0 1.0]   # 3-by-4
    m, k = size(A)
    k2, n = size(B)
    @assert k == k2 "inner dimensions must match"

    C = zeros(m, n)
    for i in 1:m          # output row
        for j in 1:n      # output column
            for r in 1:k  # the shared inner dimension
                C[i, j] += A[i, r] * B[r, j]
            end
        end
    end

    println(C)             # 7.0  5.0  4.0  4.0  /  16.0  11.0  13.0  10.0
    println(A * B)         # same numbers, built by Julia's own matrix product
    println(isapprox(C, A * B))   # true
end

# --- 6. Checking whether a matrix is symmetric -----------------------------------

# A matrix is symmetric if M[i, j] == M[j, i] for every pair of indices.
# We only need to inspect the upper triangle, because the diagonal is always fine.
let
    M = [1 2 3; 
         2 5 6; 
         3 6 9]    # symmetric by construction
    symmetric = true
    for i in 1:size(M, 1)
        for j in i:size(M, 2)    # j starts at i, so we visit the upper triangle
            if M[i, j] != M[j, i]
                symmetric = false
            end
        end
    end
    println("Matrix M is symmetric: $symmetric")           # true

    N = [1 2 3; 
         4 5 6; 
         7 8 9]   # not symmetric
    symmetric = true
    for i in 1:size(N, 1), j in i:size(N, 2)
        if N[i, j] != N[j, i]
            symmetric = false
        end
    end
    println("Matrix N is symmetric: $symmetric")           # false
end

# A shortcut: M' is the transpose. Comparing M with its transpose is the same check.
M = [1 2 3; 2 5 6; 3 6 9]
N = [1 2 3; 4 5 6; 7 8 9]
println(M == M')         # true
println(N == N')         # false

# With floating-point numbers, exact equality is too strict: tiny round-off may
# break it. Use isapprox with a tolerance instead.
let
    P = [1.0 2.0; 
         2.0 1.0]
    Q = P + [0.0 1e-14; 
             0.0 0.0]   # nearly symmetric, but not exactly
    println(P == P')                # true
    println(Q == Q')                # false  (machine noise breaks exact equality)
    println(isapprox(Q, Q'; atol = 1e-12))    # true
    println(maximum(abs.(Q - Q')))            # 1.0e-14
end


# --- 7. Rotation matrices in 2D --------------------------------------------------

# The matrix that rotates a vector counterclockwise by angle θ is
#   R(θ) = [cos θ  -sin θ;  sin θ  cos θ]
# With column vectors, the rotated point is R * p.
using LinearAlgebra
let
    θ = π / 2
    R = [cos(θ) -sin(θ); 
         sin(θ) cos(θ)]
    println(R)                       # 0.0  -1.0  /  1.0  0.0
    p = [1.0, 0.0]
    println(R * p)                   # [0.0, 1.0]   (a quarter turn)
end 

# A rotation should preserve distances, and its transpose should undo it:
# R'R = I and det(R) = 1. These are good checks that our matrix is a rotation.
let
    p = [1.0, 2.0]
    q = [-0.5, 3.0]
    θ = π / 6
    R = [cos(θ) -sin(θ); 
         sin(θ) cos(θ)]

    println(isapprox(R' * R, I; atol = 1e-14))   # true  (orthogonal)

    d_before = norm(p - q)         # distance before rotation
    d_after = norm(R * p - R * q)  # distance after rotation
    println(round(d_before; digits = 6))         # 1.802776
    println(round(d_after; digits = 6))          # 1.802776   (same distance)
end

# Rotating a shape is just rotating every vertex. The rectangle below is rotated
# by 0°, 30°, 60°, 90° and drawn each time.
let
    θs = (0.0, 30.0, 60.0, 90.0)
    rect = [0.0 0.0; 
            2.0 0.0; 
            2.0 1.0; 
            0.0 1.0]
    for θ in θs
        R = [cosd(θ) -sind(θ); 
             sind(θ) cosd(θ)]
        rotated = zeros(size(rect))  # same shape as rect
        for vertex in 1:4
            corner = [rect[vertex, 1], rect[vertex, 2]]   # the corner as a vector
            moved = R * corner                            # the rotated corner
            rotated[vertex, 1] = moved[1]
            rotated[vertex, 2] = moved[2]
        end
        println("θ = ", θ, "°  corner (2,0) -> [", round(rotated[2, 1]; digits = 3),
                ", ", round(rotated[2, 2]; digits = 3), "]")
    end
    # θ = 0.0°   corner (2,0) -> [2.0, 0.0]
    # θ = 30.0°  corner (2,0) -> [1.732, 1.0]
    # θ = 60.0°  corner (2,0) -> [1.0, 1.732]
    # θ = 90.0°  corner (2,0) -> [0.0, 2.0]
end

# --- 8. Rotation around the z axis in 3D -----------------------------------------

# In 3D, rotating around the z axis keeps the z coordinate fixed. The matrix is
#   Rz(θ) = [cos θ  -sin θ  0;  sin θ  cos θ  0;  0  0  1]
let
    θ = π / 3
    Rz = [cos(θ) -sin(θ) 0; 
          sin(θ)  cos(θ) 0; 
          0         0    1]
    println(round.(Rz * [1.0, 0.0, 0.0]; digits = 3))   # [0.5, 0.866, 0.0]
    println(round.(Rz * [0.0, 0.0, 1.0]; digits = 3))   # [0.0, 0.0, 1.0]  (unchanged)
end

# --- 9. Rotating a rectangle in the 2D plane --------------------------------------

# Rotating a shape means applying the rotation matrix to every vertex. Here we
# rotate a rectangle about the origin by 0°, 30°, 60°, ..., 330° and draw all
# the copies together on one 2D plot.
using Plots
let
    rect = [0.0 0.0; 2.0 0.0; 2.0 1.0; 0.0 1.0]

    p = plot(title = "Rectangle rotated in the xy plane",
             xlabel = "x", ylabel = "y",
             legend = false, aspect_ratio = :equal)

    for θ in 0:30:330
        R = [cosd(θ) -sind(θ); sind(θ) cosd(θ)]
        xs = Float64[]; ys = Float64[]
        for vertex in 1:4
            corner = [rect[vertex, 1], rect[vertex, 2]]
            moved = R * corner
            push!(xs, moved[1])
            push!(ys, moved[2])
        end
        # Close the polygon back to its first vertex.
        push!(xs, xs[1]); push!(ys, ys[1])
        plot!(p, xs, ys; lw = 2)
    end

    display(p)
end

# The same idea in 3D, rotating about the z axis, is the Week 4 bonus example:
# home-work-solutions/week04/bonus-week04-rectangle-3d.jl
