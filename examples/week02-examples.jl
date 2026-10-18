# week02-examples.jl
# Chapter 2 (Week 2) — examples from the lecture and recitation in one runnable file.
#
# Run the whole file:
#   julia week02-examples.jl
#
# Or send one line at a time to the Julia REPL with Shift+Enter in VS Code.
# No packages or data files are required.
#
# A trailing comment gives the value or output to expect. The script uses
# println where a displayed value would otherwise be easy to miss.

# --- 1. Values, names, and types --------------------------------------------

mass = 2.0        # kg
speed = 3.0       # m/s
momentum = mass * speed   # kg m/s
println(momentum)           # 6.0

# Assignment stores a value; changing x later does not change y.
x = 4
y = x + 1
x = 10
println("x = $x, y = $y")   # x = 10, y = 5

temperature = 20.0   # C
temperature = temperature + 0.5
println(temperature)        # 20.5

current = [0.10, 0.20, 0.30, 0.40, 0.50]   # A
n = length(current)                 # Int
I_bar = sum(current) / n            # Float64, A
axis_label = "current I [A]"        # String
analysis_ready = true               # Bool

println(typeof(n))                  # Int64
println(typeof(I_bar))              # Float64
println(typeof(axis_label))         # String
println(typeof(analysis_ready))     # Bool

println(2 * 0.35)                   # 0.7, a Float64
println(5 / 2)                      # 2.5, a Float64
println(Float64(5))                 # 5.0

# --- 2. Comparisons and Boolean logic ---------------------------------------

println(2 < 3)                      # true
println(2 == 3)                     # false
println(5 != 4)                     # true

println(true && false)              # false: both must be true
println(true || false)              # true: at least one is true
println(!true)                      # false

t = 0.35    # s
z0 = 1.20   # m
nonnegative_time = t >= 0
valid_height = z0 >= 0
valid_input = nonnegative_time && valid_height
println(valid_input)                # true

# Syntax template for a two-way decision:
#
# if condition
#     # commands when the condition is true
# else
#     # commands when the condition is false
# end

# --- 3. if, elseif, else -----------------------------------------------------

temperature = 25.0   # C
if temperature > 30
    println("hot")
else
    println("not hot")
end

# A deliberate stop. Run this line on its own to see the error; it will stop
# the current calculation. We will handle errors more fully later.
# throw(ArgumentError("message"))

t = 0.35    # s
z0 = 1.20   # m
v0 = 0.0    # m/s
g = -9.81   # m/s^2

if t < 0 || z0 < 0
    throw(ArgumentError("time and initial height must be non-negative"))
end

z_free = z0 + v0 * t + 0.5 * g * t^2   # m

if z_free > 0
    z = z_free
    state = "in air"
else
    z = 0.0
    state = "on the ground"
end

println("at t = $(t) s: z = $(round(z, digits=3)) m ($state)")

value = -2
if value < 0
    description = "negative"
elseif value == 0
    description = "zero"
else
    description = "positive"
end
println(description)                # negative

if z == 0
    state = "on the ground"
elseif z < 0.20
    state = "close to the ground"
else
    state = "in air"
end
println(state)

# --- 4. Types and explicit conversion ---------------------------------------

println(3, "  ->  ", typeof(3))
println(3.0, "  ->  ", typeof(3.0))
println("3", "  ->  ", typeof("3"))
println(3 < 4, "  ->  ", typeof(3 < 4))

println(2 + 0.5)                    # 2.5
text = "12.5"
mass = parse(Float64, text)         # kg
println(mass + 0.5)                 # 13.0
println(string(mass, " kg"))        # 12.5 kg
println(Int(7.0))                   # 7

# --- 5. Validation before a calculation -------------------------------------

temperature = -2.0   # C
println(temperature < 0)            # true
if temperature < 0
    println("below freezing")
else
    println("not below freezing")
end

if temperature < 0
    state = "ice"
elseif temperature == 0
    state = "melting-point"
else
    state = "liquid"
end
println(state)                      # ice

is_finite_positive = isfinite(2.0) && 2.0 > 0
println(is_finite_positive)         # true
println(!is_finite_positive || 2.0 == 2)   # true

# A small preview of the trigonometric and truth-table material.
println(true && false)              # false
println(true || false)              # true
println(xor(true, true))            # false
println(xor(true, false))           # true
println(sin(pi / 6))                # 0.49999999999999994
println(sind(30.0))                 # 0.5
println(round(rad2deg(atan(1.0, -1.0)); digits=1))   # 135.0

# The lesson asks us to validate text and a physical domain before calculating.
text = "2.5"  # reproducible example of text supplied by readline()
mass = parse(Float64, text)   # kg
if !isfinite(mass) || mass <= 0
    throw(ArgumentError("mass must be finite and positive"))
end
println("mass = ", mass, " kg")

# A block on an incline: static and kinetic friction.
mass = 2.0      # kg
angle = 30.0    # deg
μ_s = 0.60
μ_k = 0.40
g = 9.81        # m/s^2

if !(mass isa Real) || mass isa Bool || !isfinite(mass) || mass <= 0
    throw(ArgumentError("mass must be finite, positive, and non-Boolean"))
elseif !isfinite(angle) || !(0 <= angle < 90) || μ_k < 0 || μ_k > μ_s
    throw(ArgumentError("use 0 <= angle < 90 and 0 <= μ_k <= μ_s"))
end

θ = deg2rad(angle)              # rad
normal = mass * g * cos(θ)      # N
needed_static = mass * g * sin(θ)   # N

if needed_static <= μ_s * normal
    state = "stuck"
    acceleration = 0.0          # m/s^2
else
    state = "sliding"
    acceleration = (-needed_static + μ_k * normal) / mass   # m/s^2
end

println(state, ", a = ", acceleration, " m/s^2")

# --- 6. Recitation: a pull can reverse impending motion ---------------------

pull = 20.0      # N
mass = 5.0       # kg
angle = 20.0     # deg
tendency = pull - mass * 9.81 * sind(angle)   # N

if tendency > 0
    friction_direction = "downhill"
elseif tendency < 0
    friction_direction = "uphill"
else
    friction_direction = "none"
end

println(friction_direction)      # downhill
