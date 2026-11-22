# Week 7 — Piping, linear equations, and least-squares fitting.
# Run sections in the Julia REPL, or from the repository root:
#   julia --project=course_material course_material/examples/week07-examples.jl
# This file is independent of Week 8 and needs no CSV or DataFrames packages.
# LinearAlgebra provides rank and matrix methods; Statistics provides mean.
# Both come with Julia. Plots is already in the course environment.

using LinearAlgebra
using Statistics
using Plots

# Piping was deferred from Week 6.
# --- 0. Piping: a chain written in the order it happens -------------------------

# A nested call is read from the inside out. The pipe operator |> moves the value
# from left to right instead: x |> f means exactly f(x), and the chain reads in
# the order the calculation happens.
println(3 |> sqrt)                              # 1.7320508075688772
println(3 |> sqrt |> round)                     # 2.0
println(round(sqrt(3)))                         # 2.0  (the same, inside out)

# Start with a list of numbers: find the largest, then square it.
numbers = [3.0, 8.0, 12.0, 4.5]
square_number(x) = x^2
println(numbers |> maximum |> square_number)   # 144.0

# A pipe calls a one-argument step. For a function with more arguments,
# wrap the call in an anonymous function and choose where the value goes:
# Suppose we have:
scaled_square(scale, x) = scale * x^2
scale = 2.0
println(numbers |> maximum |> (x -> scaled_square(scale, x)))  # 288.0

# Another examples
above_five(v) = filter(x -> x > 5.0, v)
squared(v) = map(x -> x^2, v)
println(numbers |> above_five)                 # [8.0, 12.0]
println(numbers |> above_five |> squared)      # [64.0, 144.0]
println(numbers |> above_five |> squared |> sum)  # 208.0
# The same computation, with the calls nested:
println(sum(squared(above_five(numbers))))      # 208.0

# occasionally a pipe is clearer than a nested call,
# especially when the chain is long.
# The following example is a contrived one, but it shows the idea:
println([1, 2, 3, 4] |> (v -> map(x -> x^2, v)) |> (v -> filter(x -> x > 5, v)) |> sum)  # 25
# compare with:
println(sum(filter(x -> x > 5, map(x -> x^2, [1, 2, 3, 4]))))  # 25

# Try this separately: [1, 2, 3, 4] |> sin throws a MethodError because
# sin expects one number, not the whole vector. Broadcasting applies it
# to each entry instead:
println([1, 2, 3, 4] .|> sin)

# An anonymous step needs parentheses, because -> binds more loosely than |>. The
# pipe itself never adds an argument: filter(predicate) alone has one argument
# and fails, so the collection has to enter through a named or anonymous step.
println(numbers |> (v -> filter(x -> x > 5.0, v)) |> sum)  # 20.0

# Use a pipe when a reader should follow the data through several steps. For two
# or three steps the nested form is usually clearer, and for arrays the
# comprehensions above often say it best.

# --- 1. Solve a small linear system ---------------------------------------------

# M * v = b, where M is a square matrix, v is the unknown vector, and b is the right-hand side.
# e.g., for a 3x3 system:
# m00 * v0 + m01 * v1 + m02 * v2 = b0
# m10 * v0 + m11 * v1 + m12 * v2 = b1
# m20 * v0 + m21 * v1 + m22 * v2 = b2
# One can solve through calculating the inverse of M ( M^-1 M = I ), and then multiplying both sides by M^-1:
# M^-1 M v = M^-1 b, namely:
#      I v = M^-1 b, so v = M^-1 b. This is mathematically correct,
# but it is more efficient to use the backslash operator \.
# v = M \ b solves the system directly, without computing the inverse.

# 2x + y = 5, x - y = 1. The hand solution is x = 2, y = 1.
equations = [2.0 1.0; 1.0 -1.0]
rhs = [5.0, 1.0]
solution = equations \ rhs
println(round.(solution; digits = 6))           # [2.0, 1.0]
println(isapprox(equations * solution, rhs))   # true
# \ asks Julia to solve the system; it is not element-by-element division.
# Use it directly rather than computing inv(equations) * rhs.

# Or a large system!
M = rand(1000, 1000)
b = rand(1000)

# Time the two methods of solving the system. The backslash operator is usually faster and more numerically stable than computing the inverse.
@time v = M \ b ;
@time v2 = inv(M) * b;

# This is a more reliable way to benchmark the two methods, as it avoids including compilation time in the measurement, and runs many iterations to get a more accurate measurement of the time taken.
using BenchmarkTools
@benchmark M \ b
@benchmark inv(M) * b

# --- 2. More measurements than coefficients ------------------------------------

# We want y = offset + slope*x. Each measurement becomes one matrix row:
# [1 x_i] * [offset, slope] = y_i.
line_x = [0.0, 1.0, 2.0, 3.0]
line_y = [2.0, 5.0, 8.0, 11.0]
# e.g., [1 0; 1 1; 1 2; 1 3] * [offset, slope] = [2, 5, 8, 11].
# the problem we have is overdetermined: four measurements, two unknowns.
# The least-squares solution minimizes the sum of squared residuals.
# Proof in the course notes. (You don't have to know it, but it is a nice result.)

# standard least square solution we did in week 1:
# using averages, we can compute the slope and offset:
a = (mean(line_x .* line_y) - mean(line_x) * mean(line_y)) / (mean(line_x .* line_x) - mean(line_x)^2)
b = mean(line_y) - a * mean(line_x)
# i.e., y = offset + slope*x, where offset is the offset and slope is the slope.

# but we can also use the backslash operator to solve the least-squares problem directly:
construct = [ones(length(line_x)) line_x]
println(size(construct))                          # (4, 2)
# display works with the course environment alone. If PrettyTables is installed
# separately, pretty_table(construct) is an optional formatted view.
display(construct)                                        # [1.0 0.0; 1.0 1.0; 1.0 2.0; 1.0 3.0]
coefficients = construct \ line_y
println(round.(coefficients; digits = 6))        # [2.0, 3.0]
println(round.(construct * coefficients; digits = 6))  # [2.0, 5.0, 8.0, 11.0]

#=

*** Solving Linear Systems with `A \ v` in Julia

In Julia, `A \ v` solves the linear system `A*x = v`, where `A` is a matrix and `v` is a vector.

Unlike some other programming languages, Julia allows `A` to be non-square. The solution depends on the dimensions of `A`:

**1. Square matrix (m = n)**

When the number of equations equals the number of unknowns, Julia solves the system directly. If `A` is invertible, the solution is mathematically equivalent to `x = inv(A)*v`, but `A \ v` is faster and more numerically stable.

**2. Overdetermined system (m > n)**

When there are more equations than unknowns, an exact solution generally does not exist.

Julia finds the least-squares solution, minimizing the sum of squared residuals:

`||A*x - v||²`

This is particularly useful for fitting models to experimental data. For example, fitting a straight line to several measurements can be done simply with `A \ v`.

Formally it is equivalent to solving the normal equations `A'*A*x = A'*v`, but Julia uses more stable methods (like QR factorization) rather than explicitly forming `A'*A`.

**3. Underdetermined system (m < n)**

When there are fewer equations than unknowns, infinitely many solutions may exist.

Julia returns the solution with the smallest Euclidean norm (`||x||`) among all solutions that minimize the residual `||A*x - v||`.

Example: If you have a system with two unknowns but only one equation, Julia will return the solution that is closest to the origin in the solution space.

Specific example: x + y + 2z = 2 has infinitely many solutions (e.g., (2, 0, 0), (0, 2, 0), (0, 0, 1.0), etc.). Julia will return the solution with the smallest norm:

=#

M = [1 1 2]
v = [2]
solution = M \ v

#=

**4. Rank-deficient matrices**

If some columns or rows of a rectangular matrix are linearly dependent, Julia uses a rank-revealing factorization to find a minimum-norm least-squares solution.

**Summary: three formulas for A \ b (b is the right-hand side v above)**

Shape and assumption       | Mathematical solution       | What it gives
---------------------------|-----------------------------|----------------------
Square: A invertible       | x = A^(-1) * b              | Unique exact solution
Tall: independent columns  | x = (A'*A)^(-1) * A' * b    | Least-squares solution
Wide: independent rows     | x = A' * (A*A')^(-1) * b    | Shortest exact solution

For these real matrices, A' is the transpose. The formulas describe the
answers; in Julia, use A \ b rather than explicitly forming the inverses.
For a rank-deficient rectangular matrix, the solve minimizes the residual
first, then chooses a minimum-norm solution.

For a rectangular matrix, `A \ v` is mathematically equivalent (up to numerical precision) to `pinv(A)*v`, where `pinv(A)` is the Moore-Penrose pseudoinverse.

=#

# --- 3. Named tuples make several results easier to read ------------------------

# Week 6 tuples used positions. A named tuple also gives each entry a name.
line_result = (offset = coefficients[1], slope = coefficients[2])
println(round(line_result.slope; digits = 6))   # 3.0
println(round(line_result.offset; digits = 6))  # 2.0
# This is a lightweight result record; it does not require defining a new type.

"""
    fit_line(x, y)

Fit y = offset + slope*x by least squares. Return a named tuple with offset,
slope, predicted values, observed-minus-predicted residuals, and RMS residual.
The caller supplies aligned finite real vectors with at least two distinct x
values. The coefficient units are [y] and [y]/[x]; predicted/residual/RMS use [y].

Why does it work?
(Note that \\ appears as a single backslash in the code; it is escaped here for Markdown.)
`coefficients = A \\ y` computes the least-squares coefficients, minimizing
the sum of squared residuals ||y - A*coefficients||². Those coefficients
satisfy the normal equations A'*A*coefficients = A'*y; Julia does not need
to form A'*A to compute them. The predicted values are A*coefficients:
 (1   x_1 )    (offset)   =  (y_1_predict = offset + slope*x_1)
 (1   x_2 ) *  (slope )      (y_2_predict = offset + slope*x_2)
 (1   x_3 )                  (y_3_predict = offset + slope*x_3)

and the residuals are the difference between the observed y and the predicted values. The RMS residual is calculated as the square root of the mean of the squared residuals.
"""
function fit_line(x, y)
    A = [ones(length(x)) x]
    coefficients = A \ y
    predicted = A * coefficients
    residuals = y - predicted
    rms = sqrt(mean(residuals .^ 2))
    return (offset = coefficients[1], slope = coefficients[2],
        predicted = predicted, residuals = residuals, rms = rms)
end

line_x = [0.0, 1.0, 2.0, 3.0]
line_y = [2.0, 6.0, 7.0, 11.0]
line_fit = fit_line(line_x, line_y)
println(round(line_fit.rms; digits = 6))  # 0.67082

using Plots
line_predicted = line_fit.predicted
line_plot = plot(line_x, line_predicted; label="Least-squares line",
    color=:blue, linewidth=2, xlabel="x", ylabel="y", legend=:topleft)
for i in eachindex(line_x)
    label = ""
    if i == firstindex(line_x)
        label = "Vertical residuals"
    end
    heights = [line_predicted[i], line_y[i]]
    plot!(line_plot, [line_x[i], line_x[i]], heights;
        color=:gray, linestyle=:dash, linewidth=2, label=label)
end
scatter!(line_plot, line_x, line_y;
    label="Supplied values", color=:darkorange)
savefig(line_plot, joinpath(@__DIR__, "week07-line-fit.png"))
# Figure description and calculation details: week07-line-fit.caption.md/.meta.md.

# --- 4. Physics: how does a force move a chain of blocks? -----------------------
#
# PHYSICS BOX — Two blocks slide horizontally between fixed walls, joined by
# three springs. All springs are unstrained in the unloaded reference state:
#
#     fixed wall -- k_1 -- [block 1] -- k_2 -- [block 2] -- k_3 -- fixed wall
#
# We seek static equilibrium, so each block's net force is zero; its mass
# does not enter.
# x_i is displacement from the unloaded equilibrium (m), positive to the right;
# F_i is the applied force (N), positive to the right; k_j > 0 is spring j's
# stiffness (N/m). Both walls have zero displacement: x_0 = x_3 = 0.
#
# Hooke's law says that a spring's restoring force opposes its change in length.
# The middle spring's length changes by x_2-x_1. It therefore exerts
# +k_2*(x_2-x_1) on block 1 and -k_2*(x_2-x_1) on block 2.
# The end springs exert -k_1*x_1 and -k_3*x_2 on their adjacent blocks.
#
# e.g., on block 1:
#   F_k1 = -k_1*x_1 <---- [Block 1] ----> F_k2 = k_2*(x_2-x_1)
#                             |
#                             --> F_1 (applied)
#
# Including the external forces, equilibrium equations on either block are
#
#     -k_1*x_1 + k_2*(x_2-x_1) + F_1 = 0,
#     -k_2*(x_2-x_1) - k_3*x_2 + F_2 = 0.
#
# Collecting the unknown displacements on the left gives K*x=F:
#
#     [k_1+k_2    -k_2 ] * [x_1] = [F_1].
#     [  -k_2   k_2+k_3]   [x_2]   [F_2]
#
# For three identical springs, this simplifies to K = k*[2 -1; -1 2].
# A neighbor moving to the right reduces the relative displacement x_i-x_neighbor;
# collecting these differences gives the negative neighbor entries of K.
#
# Assume frictionless motion, fixed walls, and ideal Hooke-law springs within
# their linear range. We calculate equilibrium, not the time needed to reach it.
# With no applied forces every displacement is zero; equal forces on both
# blocks give equal displacements. Friction, large deformation, or moving supports
# require a different model.

# Only neighboring blocks interact, so entries away from three diagonals vanish.
# Tridiagonal(lower, main, upper), from LinearAlgebra, stores those diagonals.
# Why do we use that, because the bonus HW problem will have N blocks, and we want to avoid storing a full N×N matrix.
# fill(value, count) constructs a vector of repeated entries.

using LinearAlgebra


chain_n = 2
spring_k = 10.0                               # N/m
# without the Tridiagonal constructor, we would have to write:
stiffness = [2*spring_k -spring_k; -spring_k 2*spring_k]
# With Tridiagonal, but without fill. Each off-diagonal has n-1 entries,
# and all are used. With n=2, the lower and upper diagonals have one entry each.
stiffness = Tridiagonal([-spring_k], [2*spring_k, 2*spring_k], [-spring_k])
# with fill
stiffness = Tridiagonal(fill(-spring_k, chain_n - 1),
    fill(2 * spring_k, chain_n), fill(-spring_k, chain_n - 1))
println(size(stiffness))                       # (2, 2)

# Matrix converts the structured representation to an ordinary dense matrix.
# We can index and slice it with the matrix operations we already know.
dense_stiffness = Matrix(stiffness)
println(dense_stiffness[2, :])                  # [-10.0, 20.0]
println(stiffness == dense_stiffness)           # true

applied_forces = [0.0, 1.0]                    # N: push the right block
# Predict the ratio first: the unloaded left block has 2k*x[1]-k*x[2]=0,
# so the right block moves twice as far as the left.
equilibrium = stiffness \ applied_forces       # m
println(round.(equilibrium; digits = 6))        # [0.033333, 0.066667]
println(isapprox(stiffness * equilibrium, applied_forces))  # true
# The left block moves too: the middle spring transmits the applied force.

# Predict the effect of doubling every stiffness before solving again.
stiffer_equilibrium = (2 * stiffness) \ applied_forces
println(round.(stiffer_equilibrium; digits = 6))  # [0.016667, 0.033333]

# A matrix right-hand side lets us solve several force patterns together.
# [v1 v2] places two vectors side by side; each column is one experiment.
second_forces = [1.0, 0.0]                     # N: push the left block
force_cases = [applied_forces second_forces]
equilibrium_cases = stiffness \ force_cases
println(size(equilibrium_cases))                # (2, 2)
println(round.(equilibrium_cases[:, 2]; digits = 6))  # [0.066667, 0.033333]
println(isapprox(stiffness * equilibrium_cases, force_cases))  # true

# Superposition: adding applied forces adds their equilibrium displacements.
combined_equilibrium = stiffness \ (applied_forces + second_forces)
println(isapprox(combined_equilibrium,
    equilibrium_cases[:, 1] + equilibrium_cases[:, 2]))  # true
# Julia can exploit the three-diagonal structure to solve a chain with work
# proportional to its length. We do not need to implement that algorithm here.
# The optional bonus extends the construction to N blocks and unequal springs.

# --- 5. A quadratic is linear in its coefficients ------------------------------
#
# Consider the mathematical polynomial y = a + b*x + c*x^2.
# All numbers here are dimensionless, constructed examples.
#
# Why can a linear-system solver fit a curved graph?
# At a supplied x_i, both x_i and x_i^2 are already known numbers. We are
# solving for a, b, and c: each multiplies a known number, and no unknown
# coefficient is squared or multiplied by another unknown coefficient.
# Thus the model is linear in its coefficients even though it curves with x.
#
# For every pair (x_i, y_i), we want a + b*x_i + c*x_i^2 to approximate y_i.
# Place these equations underneath one another:
#
#     [1  x_1  x_1^2]   [a]   [y_1]
#     [1  x_2  x_2^2] * [b] ~ [y_2],       or A * coefficients ~ y.
#     [1  x_3  x_3^2]   [c]   [y_3]
#     [     ...     ]         [ ... ]
#
# That explains A = [ones(length(x)) x x .^ 2]: each column supplies one
# contribution (constant, linear, quadratic), and each row is one data point.
# Multiplying A by [a,b,c] calculates all predicted y values at once.
# The dots in x .^ 2 square each supplied x; A * coefficients is an ordinary
# matrix-vector product, adding the three contributions in each row.
#
# For example, at x = [0,1,2], the rows are [1,0,0], [1,1,1], [1,2,4].
# With y = [2,0,-12], the equations become
#     a = 2,  a+b+c = 0,  a+2b+4c = -12.
# Their solution is a=2, b=3, c=-5: the solver has found the polynomial's
# coefficients without searching over possible parabolas.
#
# Three distinct x values determine a unique quadratic (possibly c=0).
# With more points, especially perturbed ones, one quadratic usually cannot
# pass through every pair. For a candidate q=[a,b,c], define residuals
# r = y-A*q and the total squared discrepancy S = sum(r .^ 2).
# The rectangular solve A \ y chooses q that minimizes this S.
#
# Why is this the least-squares answer? At a minimum, changing a, b, or c
# slightly cannot lower S. Differentiating S with respect to each gives
#     sum(r_i) = 0,  sum(x_i*r_i) = 0,  sum(x_i^2*r_i) = 0.
# These three conditions say A' * r = 0, where A' is the transpose here
# because our entries are real. Substituting r=y-A*q gives the normal equations
#     (A' * A) * q = A' * y.
# When A has three independent columns, these conditions give the unique
# least-squares minimum. In floating-point arithmetic, A \ y uses a stable
# factorization for this full-rank dense rectangular matrix (QR); we do not
# explicitly invert A' * A, which can magnify numerical errors.
#
# The exact example below checks recovery of known coefficients. Adding
# deterministic perturbations shows what happens when the points no longer
# lie on one quadratic; RMS = sqrt(S / length(y)) summarizes the discrepancy.

"""
    fit_quadratic(x, y)

Fit y = a + b*x + c*x^2. Return a named tuple with fields constant, linear,
quadratic, predicted, residuals (supplied minus predicted), and rms.
Assume finite, aligned, dimensionless real vectors with at least three
distinct x values. This is least-squares fitting with low-degree columns,
not a general polynomial-interpolation algorithm.
"""
function fit_quadratic(x, y)
    A = [ones(length(x)) x x .^ 2]
    coefficients = A \ y
    predicted = A * coefficients
    residuals = y - predicted
    return (
        constant=coefficients[1],
        linear=coefficients[2],
        quadratic=coefficients[3],
        predicted=predicted,
        residuals=residuals,
        rms=sqrt(mean(residuals .^ 2)),
    )
end

sample_x = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
exact_values = 2.0 .+ 3.0 .* sample_x .- 5.0 .* sample_x .^ 2
exact_fit = fit_quadratic(sample_x, exact_values)
println(round.([exact_fit.constant, exact_fit.linear, exact_fit.quadratic];
    digits = 6))                              # [2.0, 3.0, -5.0]
println(round(exact_fit.rms; digits = 6))        # 0.0

perturbations = [0.02, -0.01, 0.01, -0.02, 0.0, 0.01]
sample_values = exact_values + perturbations
quadratic_fit = fit_quadratic(sample_x, sample_values)
println(round.([quadratic_fit.constant, quadratic_fit.linear, quadratic_fit.quadratic];
    digits = 6))                              # [2.017143, 2.903571, -4.910714]
println(round(quadratic_fit.rms; digits = 6))    # 0.009759
# Deterministic perturbations change the fitted coefficients. RMS summarizes
# the remaining residuals; this example supplies no probability/noise model.

# --- 6. Check whether the measurements distinguish the coefficients --------------

# rank counts independent matrix columns. If all x values are 1, every row
# is [1 1 1], so only a+b+c is determined; the three coefficients are not.
quadratic_design = [ones(length(sample_x)) sample_x sample_x .^ 2]
println(rank(quadratic_design))                # 3
repeated_x = fill(1.0, 6)
degenerate_design = [ones(6) repeated_x repeated_x .^ 2]
println(rank(degenerate_design))               # 1
# Give the fitter distinct x values rather than asking a solver to recover
# parameters that the data cannot distinguish. This example does not fit it.

# --- 7. Small executable checks -------------------------------------------------

# @test is a macro from Julia's Test standard library: it checks an expression
# and reports a failure if it is false. isapprox allows floating-point roundoff.
using Test
@test isapprox(exact_fit.constant, 2.0; atol = 1.0e-10)
@test isapprox(exact_fit.linear, 3.0; atol = 1.0e-10)
@test isapprox(exact_fit.quadratic, -5.0; atol = 1.0e-10)
@test isapprox(quadratic_fit.predicted + quadratic_fit.residuals, sample_values)
println("Synthetic recovery and residual checks passed.")
# Synthetic recovery and residual checks passed.
# Small residuals describe agreement with the supplied data within this model.

# --- 8. Plot observations, a dense fitted curve, and residuals -------------------

let
    dense_x = range(first(sample_x), last(sample_x); length = 201)
    dense_y = quadratic_fit.constant .+ quadratic_fit.linear .* dense_x .+
              quadratic_fit.quadratic .* dense_x .^ 2
    p1 = scatter(sample_x, sample_values; label = "supplied values",
        xlabel = "x", ylabel = "y")
    plot!(p1, dense_x, dense_y; label = "least-squares quadratic", linewidth = 2)

    p2 = scatter(sample_x, quadratic_fit.residuals; label = "supplied - predicted",
        xlabel = "x", ylabel = "residual")
    hline!(p2, [0.0]; color = :gray, linestyle = :dash, label = false)
    p = plot(p1, p2; layout = (1, 2), size = (1000, 430),
        left_margin = 5 * Plots.mm, bottom_margin = 5 * Plots.mm)
    savefig(p, joinpath(@__DIR__, "week07-quadratic-fit.png"))
    display(p)
end
# Figure description and calculation details: week07-quadratic-fit.caption.md/.meta.md.
# The fitted curve is evaluated between supplied x values; it is a model.
# A line connecting the measured points would be a different graphical object.
# Examine residuals for patterns, even when the main curve looks convincing.
