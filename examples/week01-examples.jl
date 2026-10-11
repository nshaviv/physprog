# week01-examples.jl
# Chapter 1 (Week 1) — every example from the lecture, in one runnable file.
#
# How to use it
#   * Whole file:   Run > Run Without Debugging (executes top to bottom).
#   * Line by line: put the cursor on a line and press Shift+Enter to send it to
#                   the Julia REPL; the REPL prints the value beneath the line.
#   * Needs the course environment (CSV, DataFrames, Plots). From the repository
#     root that contains Project.toml:  julia --project=. -e 'using Pkg; Pkg.instantiate()'
#
# In the comments below, "# =>" shows the value the REPL would display for that
# line, and a trailing "# unit" records the physical unit (Julia ignores comments).

# --- 1. Where do we see a result? -------------------------------------------
1 + 1                       # => 2   (REPL displays the value)
println(1 + 1)              # prints 2 to the REPL/terminal output

# --- 2. Julia as a calculator -----------------------------------------------
println(exp(1))             # 2.718281828459045
println(sin(pi / 2))        # 1.0        (angle in radians)
println(mod(17, 5))         # 2          (remainder of 17 / 5)
println(div(17, 5))         # 3          (integer quotient; 17 = 3*5 + 2)

# Unicode: type \pi<Tab> to get π. A numeric coefficient multiplies: 2π == 2*pi.
println(2pi)                # 6.283185307179586
println((2 + 3) * 4)        # 20
println(2^3)                # 8

# --- 3. Names for values ----------------------------------------------------
x = 2                       # => 2   (assignment: store the right side under the name)
y = 3                       # => 3
println(x + y)              # 5
println(x^2 + y^2)          # 13

# Keep names unit-free and record the unit in a short trailing comment.
voltage = 2.0               # V
current = 0.5               # A
resistance_single = voltage / current   # ohm  => 4.0

# --- 4. Dotted (element-by-element) operations ------------------------------
values = [1, 2, 3]
squared = values .^ 2       # => [1, 4, 9]
println(squared)

# --- 5. Guided measurement-to-model workflow --------------------------------
using CSV, DataFrames, Plots

# Find the supplied data file. The first candidate is the student repository
# layout (assets/data); the second is the instructor source layout, found when
# running from the course sources directory.
candidates = ("assets/data/ohm_law.csv",
              joinpath("reveal", "week01", "ohm_law.csv"))
idx = findfirst(isfile, candidates)
idx === nothing && error("ohm_law.csv not found; run from the repository root")
datafile = candidates[idx]
println("data: ", datafile)

# Step 2: load and inspect the table. CSV.read returns a DataFrame (named columns).
data = CSV.read(datafile, DataFrame)
println(first(data, 5))

# Step 3: name the physical quantities (units in comments).
current = data.current_A    # A
voltage = data.voltage_V    # V

# Step 4: make the data visible before fitting anything.
scatter(current, voltage,
    xlabel="current I [A]", ylabel="voltage V [V]",
    label="measurements", markerstrokewidth=0)

# Step 5: fit V = R*I + V0 with the direct centered-sum formulas.
n = length(current)
I_bar = sum(current) / n                    # A
V_bar = sum(voltage) / n                    # V
dI = current .- I_bar                       # A
dV = voltage .- V_bar                       # V
resistance = sum(dI .* dV) / sum(dI .^ 2)   # ohm
offset = V_bar - resistance * I_bar         # V
println("R = $(round(resistance, digits=3)) ohm")
println("offset = $(round(offset, digits=3)) V")

# Step 6: put the fitted model on the same graph and save the figure.
scatter(current, voltage,
    xlabel="current I [A]", ylabel="voltage V [V]",
    label="measurements", markerstrokewidth=0)
plot!(current, resistance .* current .+ offset,
    label="least-squares model", linewidth=2)
savefig("ohm_law_fit.png")
println("R = $(round(resistance, digits=3)) ohm")
println("offset = $(round(offset, digits=3)) V")

# Step 7: inspect the residuals (voltage minus model); they should straddle zero.
residual = voltage .- (resistance .* current .+ offset)   # V
scatter(current, residual,
    xlabel="current I [A]", ylabel="residual V - model [V]",
    label="residuals", markerstrokewidth=0)
hline!([0], label="zero residual")
savefig("ohm_law_residuals.png")

# --- 6. Smallest exact fit: (0,1), (1,3), (2,5) all lie on y = 2x + 1 --------
ex = [0, 1, 2]
ey = [1, 3, 5]
ex_bar = sum(ex) / length(ex)
ey_bar = sum(ey) / length(ey)
slope = sum((ex .- ex_bar) .* (ey .- ey_bar)) / sum((ex .- ex_bar) .^ 2)   # 2.0
icpt = ey_bar - slope * ex_bar                                             # 1.0
println("slope = $slope, intercept = $icpt")   # slope = 2.0, intercept = 1.0
