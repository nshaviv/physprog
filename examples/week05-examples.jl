# Week 5 — Functions (revised teaching outline, 2026-11-07).
# Run sections in the Julia REPL, or run the whole file in the course environment.
# The REPL displays a final expression automatically. A script needs println
# for text and display for figures; those calls below keep whole-file runs useful.
# LinearAlgebra is supplied with Julia. Plots, used near the end, is already
# in the course environment.

# --- 1. Define a function, then call it ------------------------------------------

# Start with one argument. The caller supplies a number; return sends the
# calculated value back to the caller.
function double_number(x)
    return 2 * x
end

# You can also define as a one-line function. The following is equivalent to the above.
double_number(x) = 2 * x

println(double_number(3))                      # 6

# Call the same function once for each value in a familiar loop.
for n in 1:5
    println(double_number(n))
end
# 2
# 4
# 6
# 8
# 10

# Now give a function two arguments. Working names inside a function are local.
# For this geometric example, width and height are nonnegative lengths in the
# same unit, and the returned area is in that unit squared.
function rectangle_area(width, height)
    area = width * height
    return area
end

println(rectangle_area(3, 4))                   # 12

# A one-line definition is convenient for a short calculation.
square(x) = x * x
println(square(5))                            # 25

# --- 2. Scope: global names, functions, begin, and let ---------------------------

# A scope determines which binding a name refers to. At the top level of this
# file (or the REPL), assignment creates or changes a global binding.
x = 10
println("Global x = ", x)                    # Global x = 10

# Assigning x inside a function creates a local binding. It shadows the global
# name for that function, leaving the global value unchanged.
function scope_function_x()
    x = 20
    return x
end
println("Function's local x = ", scope_function_x())  # Function's local x = 20
println("After function, global x = ", x)    # After function, global x = 10

# begin groups statements; it creates NO new scope. Here it is at top level,
# so the assignment changes the same global x that we created above.
begin
    x = 30
    println("Inside top-level begin, x = ", x)  # Inside top-level begin, x = 30
end
println("After begin, global x = ", x)       # After begin, global x = 30

# let creates a local scope. Its assignment makes a fresh local x.
let
    x = 40
    println("Inside let, local x = ", x)     # Inside let, local x = 40
end
println("After let, global x = ", x)         # After let, global x = 30

# Put begin inside a function and it shares THAT function's local scope.
function scope_function_begin_x()
    x = 50
    begin
        x = 60
    end
    return x
end
println("Function with begin returns ", scope_function_begin_x())  # 60
println("Global x is still ", x)             # Global x is still 30
# begin always uses its surrounding scope; it is not inherently global.
# These examples reassign numbers. Local scope does not copy objects: a local
# name can still refer to a shared array, as the mutation example below shows.

# --- 3. Positional arguments, keyword arguments, and defaults -------------------

# Positional arguments are identified by their order.
function difference(a, b)
    return a - b
end
println(difference(10, 3))                     # 7
println(difference(3, 10))                     # -7

# A default fills in an omitted positional argument.
function shifted(x, amount = 1)
    return x + amount
end
println(shifted(5))                            # 6
println(shifted(5, 10))                        # 15

# If there is more than one default positional argument missing, it fills from the right. 
# The caller can supply the leftmost argument and omit the rightmost. 
function confusing(x, y = 10 , z = 100)
    return x + y + z
end
confusing(3,1) # = 3 + 1 + 100 = 104 
confusing(3)   # = 3 + 10 + 100 = 113

# The semicolon introduces keyword arguments. Name them at the call site.
function affine(x; scale = 1, offset = 0)
    return scale * x + offset
end
println(affine(3))                            # 3
println(affine(3; scale = 2, offset = 1))      # 7
println(affine(3; offset = 1, scale = 2))      # 7 (keyword order is flexible)

# A keyword argument can be omitted if it has a default. The caller can supply
# julia isn't picky about the order of keyword arguments, but it is picky about the order of positional arguments.
# julia isn't picky about the ; when calling a function, but it is necessary when defining a function with keyword arguments.
affine(3, offset = 1) # = 3 + 0 + 1 = 4

# --- 4. return, implicit return, and nothing ------------------------------------

# Without an explicit return, Julia returns the last expression.
function cube(x)
    x^3
end
println(cube(3))                              # 27

# A return inside a loop exits the whole function. nothing can represent the
# absence of an answer, instead of using a special numeric value "nothing".

function first_positive(values)
    for value in values
        if value > 0
            return value
        end
    end
    return nothing
end
println(first_positive([-2, 0, 5, 9]))        # 5
println(first_positive([-2, 0]))              # nothing

a = nothing
if a == nothing
    println("a is nothing")
else
    println("a is not nothing")
end

# Note that there are other special values in Julia, such as Inf, -Inf, and NaN. These are not the same as nothing. For example:
a = 1/0
println("a is ",a, "    Is a>0 ? : ",a > 0)   
println("-1/0 is ", -1/0)
println("0/0 is ", 0/0)

# Note:
# println as the last expression of a function returns nothing, not the printed number. Use return to send a value back to the caller.
function print_square(x)
    println(x^2)
end
answer = print_square(4)                     # prints 16
println(answer)                              # nothing (println's return value)
answer = square(4)
println(answer + 1)                          # 17
# Tip: return a calculated result so the caller can use it. Print at the call
# site when you want to display it. Printing alone does not return the number.

# --- 5. The ! convention: changing an existing object ---------------------------

# An exclamation mark is a naming convention for a function that mutates one
# or more arguments. Julia does not enforce it. Here the vector's contents change.
function double_values!(values)
    for i in eachindex(values)
        values[i] = 2 * values[i]
    end
    return values
end
values = [1, 2, 3]
another_name = values
another_vector = copy(values)  # a separate copy, not the same object
double_values!(values)
println(values)                              # [2, 4, 6]
println(another_name)                        # [2, 4, 6] (the same vector)
println(another_vector)                      # [1, 2, 3] (a separate copy)

# Reassigning a name is different: it makes that name refer to another object.
values = [10, 20, 30]
println(values)                              # [10, 20, 30]
println(another_name)                        # [2, 4, 6]
println(another_vector)                      # [1, 2, 3]
# A ! in the name cannot make a function rebind the caller's scalar variable.

# --- 6. Broadcasting: apply a scalar calculation element by element ------------
# We have already seen this, for example, with the dot in deg2rad.(angles_deg) in week04-examples.jl.

xs = [1, 2, 3]
println(square.(xs))                         # [1, 4, 9]
println(sqrt.([1.0, 4.0, 9.0]))              # [1.0, 2.0, 3.0]
println(shifted.(xs, 10))                    # [11, 12, 13] (repeat the scalar 10)
println(affine.(xs; scale = 2, offset = 1))   # [3, 5, 7]
# Keywords remain the same for each scalar call.
println(xs .^ 2 .+ 1)                        # [2, 5, 10]
println(xs .* [10, 20, 30])                  # [10, 40, 90]
# square(xs) tries xs*xs, which has no vector-vector multiplication method.
# square.(xs) calls square on each number. A dot does not itself mean mutation.

# A macro transforms code. @. inserts dots into the calls and operators in the
# following expression, letting us write an element-by-element scalar formula.
grid = [-2.0, -1.0, 0.0, 1.0, 2.0]           # dimensionless coordinates
gaussian_dotted = exp.(-0.5 .* grid .^ 2)
gaussian_macro = @. exp(-0.5 * grid^2)
println(round.(gaussian_macro; digits = 4))   # [0.1353, 0.6065, 1.0, 0.6065, 0.1353]
println(gaussian_dotted == gaussian_macro)    # true

# An assignment INSIDE @. becomes .= and fills an existing array in place.
# Above, assignment was outside the macro, so it bound a newly computed vector.
gaussian_buffer = zeros(length(grid))
@. gaussian_buffer = exp(-0.5 * grid^2)
println(round.(gaussian_buffer; digits = 4))  # [0.1353, 0.6065, 1.0, 0.6065, 0.1353]
# Keep println and reductions such as sum outside @. unless you intend to
# broadcast those calls too. Here only the scalar formula belongs inside it.


# --- 7. Comprehensions: loops that build vectors and matrices -------------------

squares_loop = zeros(Int, 4)
for i in 1:4
    squares_loop[i] = i^2
end
println(squares_loop)                        # [1, 4, 9, 16]
squares_comp = [i^2 for i in 1:4]
println(squares_comp)                        # [1, 4, 9, 16]

table_loop = zeros(Int, 3, 4) # 3 rows, 4 columns
for i in 1:3
    for j in 1:4
        table_loop[i, j] = i * j
    end
end
# A comma between generators creates a two-dimensional matrix.
table_comp = [i * j for i in 1:3, j in 1:4]
println(table_comp)                          # [1 2 3 4; 2 4 6 8; 3 6 9 12]
println(table_loop == table_comp)            # true
# Each comprehension computes and returns a new array. We can use the explicit
# loop when storing several results or making several decisions per iteration.

# A comprehension can include an if condition to filter the results:
[n^2 for n in 1:10 if n % 2 == 0]   # [4, 16, 36, 64, 100] (even squares)

# --- 8. Divisors and primes ------------------------------------------------------

# A positive divisor of n divides it with no remainder. Writing the divisors first
# makes the definition of a prime explicit: exactly two of them, 1 and n itself.
# This definition keeps 2 prime ([1, 2]) and leaves 1 out (it has only [1]). It also
# avoids the shortcut of calling any number with no small divisor prime.

# Notice the docstring
# Docstrings are triple-quoted text immediately before a definition. They explain
# inputs, units, returned results, and assumptions. They are displayed by the
# REPL help system when you type ?function_name.
# Or with the cursor above the function

"""
    divisors(n)

Args: n, an integer number

Return: in increasing order, all positive divisors of n. Integers below 1 have
none. The loop checks every candidate up to n: simple to read, though checking only
up to isqrt(n) and pairing d with n/d would be faster.
"""
function divisors(n)
    result = Int[]
    for d in 1:n
        if n % d == 0
            push!(result, d)
        end
    end
    return result
end

println(divisors(1))                          # [1]
println(divisors(2))                          # [1, 2]
println(divisors(12))                         # [1, 2, 3, 4, 6, 12]
println(divisors(0))                          # Int64[] (no positive divisors)

# The same vector, built with the comprehension from section 7.
list_divisors = [d for d in 1:12 if 12 % d == 0]
println(list_divisors == divisors(12))   # true

# Now the definition. A prime has exactly two positive divisors.
"""
    is_prime(n)

Return true when n has exactly two positive divisors, 1 and itself.
"""
function is_prime(n)
    return length(divisors(n)) == 2
end

println(is_prime(1))                          # false: one divisor
println(is_prime(2))                          # true: 1 and 2
println(is_prime(12))                         # false
println(is_prime(97))                         # true
println([n for n in 1:30 if is_prime(n)])     # [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]

# --- 9. Physics: a pendulum, integrated with Euler --------------------------------

# PHYSICS BOX
#
# A point mass hangs on a massless RIGID rod of length L (m) from a fixed,
# frictionless pivot, in uniform gravity g (m/s^2). A rigid rod allows releases
# above 90 degrees; a flexible string released from rest there would go slack.
# θ is measured in radians from the downward vertical, positive counterclockwise,
# and ω is its angular velocity in rad/s.
#
# The equation of motion, without the small-angle approximation:
#     θ'' = -(g/L) * sin(θ)
#
# Written as two first-order equations, exactly as `pendulum_rhs` returns them:
#     dθ/dt = ω
#     dω/dt = -(g/L) * sin(θ)
#
# Small-angle limit:
#     sin(θ) ≈ θ   =>   θ'' ≈ -(g/L) * θ   =>   T0 = 2π * sqrt(L/g)
#
# Release from rest at 0 < θ0 < π. Symmetry makes the first downward zero
# crossing one quarter of a full oscillation. No damping, driving, rod
# elasticity, or pivot motion is modeled. The nonlinear period grows with
# amplitude and diverges as θ0 approaches π.

# A docstring is the triple-quoted text immediately before a definition.
# It explains inputs, units, returned results, and assumptions.
"""
    pendulum_rhs(state; length = 1.0, gravity = 9.81)

Return [dθ/dt, dω/dt] for the ideal rigid-rod pendulum. state is [θ, ω], with
θ in radians and ω in rad/s. length is in meters and gravity in m/s^2.
"""
function pendulum_rhs(state; length = 1.0, gravity = 9.81)
    θ, ω = state
    return [ω, -(gravity / length) * sin(θ)]
end

# Forward Euler updates the state with the derivative at the current time:
#     state_next = state_now + dt*derivative_now.
# Small dt is needed for this approximation; we keep the code short rather than
# adding a more accurate scheme. The first downward zero crossing is T/4.
"""
    pendulum_period(θ0; length = 1.0, gravity = 9.81, dt = 0.001)

Return the period in seconds for release from rest at angle θ0 (radians).
Euler-integrate until the first downward zero crossing and multiply its time
by four. θ0 is between 0 and π; dt is in seconds.
"""
function pendulum_period(θ0; length = 1.0, gravity = 9.81, dt = 0.001)
    state = [θ0, 0.0]
    t = 0.0
    while true
        derivative = pendulum_rhs(state; length = length, gravity = gravity)
        θ = state[1]
        θ_next = θ + dt * derivative[1]
        state[1] = θ_next
        state[2] = state[2] + dt * derivative[2]
        if θ_next <= 0
            crossing = t + dt * θ / (θ - θ_next)
            return 4 * crossing
        end
        t += dt
    end
end

# This is the small angle limit, which is independent of the release angle.
pendulum_period(0.001)
pendulum_period(0.01)
pendulum_period(0.1)
pendulum_period(1.0)

# --- 10. Plot the period as a function of the release angle ---------------------

# The comprehension repeats pendulum_period for each angle. Plots draws the result.
using Plots
let
    angles_deg = 5:5:175
    periods = [pendulum_period(deg2rad(θ)) for θ in angles_deg]
    p = plot(angles_deg, periods; xlabel = "Release angle (degrees)",
        ylabel = "Period (s)", title = "Pendulum period", legend = false,
        linewidth = 2, marker = :circle, markersize = 3)
    # @__DIR__ supplies this script's directory, so saving works from any folder.
    savefig(p, joinpath(@__DIR__, "week05-pendulum-period.png"))
    display(p)
    println("Saved week05-pendulum-period.png")
end
