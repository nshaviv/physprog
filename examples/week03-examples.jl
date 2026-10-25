# week03-examples.jl
# Chapter 3 (Week 3) — examples from the lecture in one runnable file.
#
# How to run: send lines to the Julia REPL, or open this file in VS Code and
# run cells with Shift+Enter. The examples are also exactly the code cells of
# the Chapter 3 lecture notebook. Requires the course environment (Plots is
# used only for the final Euler-vs-exact comparison plot); no data files.
#
# Note: this file is meant for interactive use (REPL / VS Code / notebook).
# Running the whole file with `julia week03-examples.jl` will stop at the
# first accumulator loop with a soft-scope warning; we discuss local variables
# properly in Week 5, when we introduce functions.
#
# A trailing comment gives the value or output to expect. The script uses
# println where a displayed value would otherwise be easy to miss.

# --- 1. Creating vectors -----------------------------------------------------

v = [10, 20, 30, 40]
empty_int = Int[]
println(v)                  # [10, 20, 30, 40]
println(empty_int)          # Int64[]
println(zeros(5))           # [0.0, 0.0, 0.0, 0.0, 0.0]
println(ones(4))            # [1.0, 1.0, 1.0, 1.0]
println(collect(1:5))       # [1, 2, 3, 4, 5]
println(range(0, 1; length=6))  # 0.0:0.2:1.0 (a range, not a vector)

# --- 2. Indexing and slicing -------------------------------------------------

v = [10, 20, 30, 40, 50]
println(v[1])               # 10
println(v[end])             # 50
println(v[2:4])             # [20, 30, 40]
println(v[2:end])           # [20, 30, 40, 50]
v[2:3] = [99, 88]
println(v[[1, 3, 5]])       # [10, 88, 50]
indices = [2, 3]
println(v[indices])         # [99, 88]
println(v)                  # [10, 99, 88, 40, 50]

# --- 3. Copy, alias, and view ------------------------------------------------

a = [1, 2, 3]
b = a
c = a[1:2]
d = copy(a)
e = @view a[1:2]
a[1] = 2
println("a[1]=", a[1], " b[1]=", b[1], " c[1]=", c[1], " d[1]=", d[1], " e[1]=", e[1])

# --- 4. Changing a vector ----------------------------------------------------

v = [1, 2, 3]
push!(v, 4); println(v)     # [1, 2, 3, 4]
append!(v, [5, 6]); println(v)   # [1, 2, 3, 4, 5, 6]
pop!(v); println(v)         # [1, 2, 3, 4, 5]
insert!(v, 2, 99); println(v)    # [1, 99, 2, 3, 4, 5]
deleteat!(v, 2); println(v)  # [1, 2, 3, 4, 5]

w = vcat(v, [7, 8]); println(w); println(v)
# [1, 2, 3, 4, 5, 7, 8]
# [1, 2, 3, 4, 5]

# --- 5. Vector arithmetic and useful functions -------------------------------

a = [1.0, 2.0, 3.0]
b = [4.0, 5.0, 6.0]
println(a + b)              # [5.0, 7.0, 9.0]
println(2a)                 # [2.0, 4.0, 6.0]
println(sum(a))             # 6.0
println(maximum(a))         # 3.0
println(minimum(a))         # 1.0
println(length(a))          # 3
println(a .* b)             # [4.0, 10.0, 18.0]
println(a .^ 2)             # [1.0, 4.0, 9.0]
println(sqrt.(a))           # [1.0, 1.4142135623730951, 1.7320508075688772]
using LinearAlgebra
println(dot(a, b))          # 32.0
println(round(norm([1,1]); digits=4))   # sqrt(2) = 1.4142

# --- 6. Several ways to iterate ----------------------------------------------

v = [10, 20, 30]
for i in 1:3
    println(i)
end                         # 1, 2, 3
for x in v
    println(x)
end                         # 10, 20, 30
for i in eachindex(v)
    println("index = ", i, ", value = ", v[i])
end                         # index = 1, value = 10 ...
for (i, x) in enumerate(v)
    println(i, " => ", x)
end                         # 1 => 10 ...

# --- 7. Accumulators ----------------------------------------------------------

# Sum without sum(v).
begin
    v = [3, 5, 8, 2]
    total = 0
    for x in v
        total += x
    end
    println(total)          # 18
    println(sum(v))         # 18
end

# Factorial.
begin
    f = 1
    for n in 1:5
        f = f * n
    end
    println(f)              # 120
end

# Count positive values.
begin
    v = [-2, 3, 0, 7, -1]
    count_positive = 0
    for x in v
        if x > 0
            count_positive += 1
        end
    end
    println(count_positive) # 2
end

# Maximum without maximum.
begin
    v = [4, 9, 2, 7]
    largest = v[1]
    for x in v
        if x > largest
            largest = x
        end
    end
    println(largest)        # 9
end

# Cumulative sums.
begin
    v = [2, 3, 5, 7]
    running = 0
    cumulative = Int[]
    for x in v
        running += x
        push!(cumulative, running)
    end
    println(cumulative)     # [2, 5, 10, 17]
    println(cumsum(v))      # [2, 5, 10, 17]
end

# --- 8. Dot product without dot ----------------------------------------------

using LinearAlgebra
begin
    a = [1.0, 2.0, 3.0]
    b = [4.0, 5.0, 6.0]
    s = 0.0
    for i in eachindex(a, b)
        s += a[i] * b[i]
    end
    println(s)              # 32.0
    println(dot(a, b), " ", a⋅b)      # 32.0 \cot + tab
end

# --- 9. Summaries: mean and sample standard deviation --------------------------

using Statistics
measurements = [1.0, 2.0, 3.0]   # m
println(mean(measurements)) # 2.0
println(std(measurements))  # 1.0

# --- 10. break -------------------------------------------------

for n in 1:10
    if n^2 >= 20
        println("first square at least 20 is $(n^2)")
        break
    end
end                         # first square at least 20 is 25

# --- 11. First Euler simulation ------------------------------------------------

# How do we integrate?
#
# simple equation
# dx/dt = v
# approximation: dx/dt ≈ (x(t+dt) - x(t)) / dt
# So:
# x(t+dt) = x(t) + v * dt
#
# If we have a vector r, we can similarly write
# dr/dt = v
# or if we approximate the derivative:
# r(t+dt) = r(t) + v * dt
#
# We can do the same for velocity, if we have an acceleration a:
# dv/dt = a
# or approximating the derivative:
# v(t+dt) = v(t) + a * dt
#
# So the values at the new time step are computed from the values at the previous time step.
# This is called Euler's method. It is a simple numerical integration method, and it is not very accurate, but it is easy to implement and understand.

# Here we solve the ballistic motion problem using Euler's method.
# The equations are
# dr/dt = v
# dv/dt = a
# or
# r(t+dt) = r(t) + v * dt
# v(t+dt) = v(t) + a * dt
# or with x and y components:
# x(t+dt) = x(t) + vx * dt
# y(t+dt) = y(t) + vy * dt
# vx(t+dt) = vx(t) + ax * dt
# vy(t+dt) = vy(t) + ay * dt
#
# Here we use a for loop to iterate over the time steps, and we store the trajectory in two arrays, one for x and one for y. We also store the velocities in two arrays, one for vx and one for vy. We can then plot the trajectory and compare it to the exact solution.

# We use *let* instead of *begin* to create a local scope for the variables. More about it when we learn about functions in the near future.
# This will avoid the soft-scope warning when running the whole file at once,
# and it is a good practice to avoid polluting the global scope with variables that are only used in a small part of the code.
using Plots
let
    # We will store the trajectory in two arrays, one for x and one for y. We will also store the velocities in two arrays, one for vx and one for vy.
    trajectory_x = Float64[]
    trajectory_y = Float64[]
    velocities_x = Float64[]
    velocities_y = Float64[]
    # We will use the following parameters:
    g = 9.81;        # gravity in m/s^2
    speed = 20.0;    # initial speed in m/s
    theta = pi / 4;  # initial angle in radians
    dt = 0.1;        # time step in seconds
    T = 2.0          # total time in seconds
    r = [0.0, 0.0]   # m
    v = [speed * cos(theta), speed * sin(theta)]   # m/s
    a = [0.0, -g]    # m/s^2
    N = round(Int, T / dt)  # number of time steps
    # We will use a for loop to iterate over the time steps, and we will store the trajectory in the arrays. We will also store the velocities in the arrays.
    # We begin by storing the initial position and velocity in the arrays.
    trajectory_x = [r[1]]
    trajectory_y = [r[2]]
    velocities_x = [v[1]]
    velocities_y = [v[2]]
    for step in 1:N
        # We update the position and velocity using Euler's method.
        r = r + v * dt
        v = v + a * dt
        # We store the new position and velocity in the arrays.
        push!(trajectory_x, r[1])
        push!(trajectory_y, r[2])
        push!(velocities_x, v[1])
        push!(velocities_y, v[2])
    end
    println("Euler final position: ", round(r[1]; digits=4), ", ", round(r[2]; digits=4))
    # Euler final position: 28.2843, 9.6453
    # Draw the saved samples while they remain in this local work area.
    r0 = [0.0, 0.0]
    v0 = [speed * cos(theta), speed * sin(theta)]
    p = plot(title="Projectile Motion: Euler vs Exact", xlabel="x (m)", ylabel="y (m)", frame=:box)
    p = plot!(p, trajectory_x, trajectory_y, label="Euler", lw=2)
    p = scatter!(p, trajectory_x, trajectory_y, label=:none, lw=2)
    exact_trajectory_x = Float64[]
    exact_trajectory_y = Float64[]
    ts = 0:dt:T
    for t in ts
        push!(exact_trajectory_x, r0[1] + v0[1] * t + 0.5 * a[1] * t^2)
        push!(exact_trajectory_y, r0[2] + v0[2] * t + 0.5 * a[2] * t^2)
    end
    p = plot!(p, exact_trajectory_x, exact_trajectory_y, label="Exact", lw=2, ls=:dash)
    display(p)
end

# --- 12. Refinement: compare with the exact answer ------------------------------

# Here we calculate the exact answer for the final position after T seconds, and we compare it to the Euler result.
# The exact answer is given by the equations of motion:
# x(T) = x0 + vx0 * T + 0.5 * ax * T^2
# y(T) = y0 + vy0 * T + 0.5 * ay * T^2
# where x0 and y0 are the initial positions, vx0 and vy0 are the initial velocities, and ax and ay are the accelerations.
# We can then calculate the error as the norm of the difference between the Euler result and the exact result. We can also vary the time step dt and see how the error decreases as dt decreases. This is called refinement, and it is a way to check the accuracy of the numerical method.
using LinearAlgebra
let
    g = 9.81; speed = 20.0; theta = pi / 4; T = 2.0
    r0 = [0.0, 0.0]
    v0 = [speed * cos(theta), speed * sin(theta)]
    a = [0.0, -g]
    for dt in (0.2, 0.1, 0.05, 0.02)
        r = copy(r0); v = copy(v0)
        N = round(Int, T / dt)
        for step in 1:N
            r = r + v * dt
            v = v + a * dt
        end
        exact = r0 + v0 * T + 0.5 * a * T^2
        println("dt = $dt, error = ", round(norm(r - exact); digits=4), " m")
    end
    # dt = 0.2, error = 1.962 m
    # dt = 0.1, error = 0.981 m
    # dt = 0.05, error = 0.4905 m
    # dt = 0.02, error = 0.1962 m
end
