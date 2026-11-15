# Week 6 — More functions.

# --- 1. Revisiting One-line definitions -----------------------------------------------------

# Week 5 introduced the long form and its short form. The short form is worth
# using when the body is a single, readable expression.
speed(distance, time) = distance / time
period(length, g=9.81) = 2 * pi * sqrt(length / g)
kinetic(mass, velocity) = mass * velocity^2 / 2

println(speed(100.0, 9.58))                     # 10.438413361169102
println(round(period(1.0); digits = 4))  # 2.0061
println(kinetic(2.0, 3.0))                      # 9.0

# A one-liner is not a different kind of function; it is the same definition with
# the body on the same line. Once the body needs a loop, a decision, or more than
# one step, the long form reads better:
function kinetic_verbose(mass, velocity)
    if (mass < 0 || velocity < 0)
        error("mass and velocity must be non-negative")
    end
    energy = mass * velocity^2 / 2
    return energy
end

# --- 2. Anonymous functions ------------------------------------------------------

# Some functions are needed once, at the point of use.
# An anonymous function is written with -> and has no name.
# Also note that functions are values, so they can be assigned to variables,
# passed as arguments, and returned from other functions.
# Here we assign an anonymous function to a variable, which gives it a name for later use:
square_it = x -> x^2
println(square_it(6))                           # 36
println(square_it isa Function)                 # true
# The type name is generated (something like var"#1#2") and differs between
# sessions, so we do not print it; what matters is that it is a Function.

# Two arguments are written the same way, with the arrow after the list:
multiply_it = (a, b) -> a * b
println(multiply_it(3, 4))                      # 12

# An anonymous function can be passed directly, without ever naming it:
println((x -> x^2)(6))                          # 36

# The usual place to meet them is as an argument to another function, which is
# where we go next.

# --- 3. Argument types -----------------------------------------------------------

# An argument can be annotated with a type. The annotation restricts which calls
# the function accepts; it does not convert anything.
halve(x::Float64) = x / 2
println(halve(3.0))                             # 1.5
println(halve(3))                               # Throws a MethodError:
# halve(3) fails with a MethodError: 3 is an Int, and there is no method for
# Int. Julia does not quietly convert it to 3.0.

# A wider annotation accepts more types. Real covers Int and Float64:
halve_any(x::Real) = x / 2
println(halve_any(3))                           # 1.5
println(halve_any(3.0))                         # 1.5

# Untyped arguments accept anything the body can handle:
add(a, b) = a + b
println(add(2, 3))                              # 5
println(add([1, 2], [3, 4]))                    # [4, 6]
# "Untyped" does not mean "works for everything": add("ab", "cd") fails, because
# + is not string concatenation in Julia (that is the * operator). The function is
# as general as the operations in its body.

# Collections (like vectors, matrices) can be annotated too, which documents the intent and catches
# mistakes early:
mean_of(v::AbstractVector) = sum(v) / length(v)
println(mean_of([1.0, 2.0, 3.0]))               # 2.0
println(mean_of([1, 2, 3]))                     # 2.0
println(mean_of(1,2,3))                           # 2.0

# Use annotations when a different type would be a mistake, and leave the
# argument untyped when any type that supports the operations is fine.

# --- 4. Functions as arguments ---------------------------------------------------

# A function is a value, so it can be an argument. This lets us write one routine
# that works for any function we hand it. A numerical slope is the natural
# example: we need the function itself, not its values.
function derivative(f, x; h = 1.0e-6)
    return (f(x + h) - f(x - h)) / (2 * h)
end

println(round(derivative(square_it, 3.0); digits = 6))  # 6.0  (d/dx x^2 = 2x)
println(round(derivative(x -> x^3, 2.0); digits = 6))  # 12.0 (3x^2)
println(round(derivative(sin, 0.0); digits = 6))     # 1.0  (d/dx sin = cos)

# The argument f is untyped on purpose: any callable object works, whether it is
# a named function, a one-liner, or an anonymous function.
# if we want to restrict the argument to a function, we can annotate it with ::Function:
derivative(f::Function, x; h = 1.0e-6) = (f(x + h) - f(x - h)) / (2 * h)
println(round(derivative(sin, 0.0); digits = 6))     # 1.0

# A physical version: the derivative of a position gives a velocity.
# The same derivative routine answers this:
height(t) = 10.0 - 4.905 * t^2                          # m, free fall
println(round(height(1.0); digits = 4))         # 5.095
println(round(derivative(height, 1.0); digits = 4))  # -9.81 (velocity, m/s)

# --- 5. The complex type ---------------------------------------------------------

# Julia has a built-in Complex type.
# The imaginary unit is written im (=sqrt(-1)), and the
# type is parameterized by the type of its parts.
z = 3.0 + 4.0im
println(z)                                      # 3.0 + 4.0im
println(typeof(z))                              # ComplexF64
zi = 3 + 4im
println(typeof(zi))                                     # 3 + 4im

println(real(z))                                # 3.0
println(imag(z))                                # 4.0
println(abs(z))                                 # 5.0   (the norm, absolute value, |z|)
println(round(angle(z); digits = 4))            # 0.9273 (the phase, in radians)
println(conj(z))                                # 3.0 - 4.0im
println(z * conj(z))                            # 25.0 + 0.0im  (= |z|^2, real)
println(z * z')
# ' is the adjoint (conjugate transpose) operator, so z * z' is a 1x1 matrix with the same value as above.
# Note if you have a matrix A, then A' is the conjugate transpose of A

M = [1.0 + 2.0im 3.0 + 4.0im; 5.0 + 6.0im 7.0 + 8.0im]
M'
transpose(M)  # the transpose without conjugation

# Complex arithmetic follows the usual rules: im^2 = -1, and multiplying by
# exp(im*theta) rotates by theta.
println(im^2)                                   # -1 + 0im
println(round(exp(im * pi); digits = 3))        # -1.0 + 0.0im  (Euler's identity)

# A real square root of a negative number is a DomainError; the complex one is fine:
println(sqrt(-4.0))                              # DomainError: no real square root exists.
println(sqrt(-4.0 + 0.0im))                     # 0.0 + 2.0im
# sqrt(-4.0) on its own would stop with DomainError: no real square root exists.

# --- 6. Multiple dispatch --------------------------------------------------------

# First choose the behavior inside one function. x isa Int asks whether x has
# type Int; the if/elseif chain decides which description to return.
function describe_with_if(x)
    if x isa Int
        return "an integer: $(x)"
    elseif x isa Float64
        return "a float: $(x)"
    elseif x isa String
        return "a string of $(length(x)) characters"
    elseif x isa Complex
        return "a complex number with modulus $(round(abs(x); digits = 3))"
    else
        return "a is of type $(typeof(x))"
    end
end

println(describe_with_if(7))                    # an integer: 7
println(describe_with_if(7.0))                  # a float: 7.0
println(describe_with_if("physics"))            # a string of 7 characters
println(describe_with_if(3.0 + 4.0im))           # a complex number with modulus 5.0
println(describe_with_if([1, 2, 3]))             # a is of type Vector{Int64}

# Now express the same choices as separate methods. We keep a different name
# for the first version so we can compare their results.
# One named function can have several methods, and Julia picks the method from the types of
# the arguments at the call. This is called multiple dispatch. No if-chain over
# types is needed.
describe(x::Int) = "an integer: $(x)"
describe(x::Float64) = "a float: $(x)"
describe(x::String) = "a string of $(length(x)) characters"
describe(z::Complex) = "a complex number with modulus $(round(abs(z); digits = 3))"
# This is the fallback method for any other type
describe(x) = "a is of type $(typeof(x))"

println(describe(7))                            # an integer: 7
println(describe(7.0))                          # a float: 7.0
println(describe("physics"))                    # a string of 7 characters
println(describe(3.0 + 4.0im))                  # a complex number with modulus 5.0
println(describe([1, 2, 3]))                     # a is of type Vector{Int64}


# Each call above reaches a different method. Asking Julia shows the table:
println(length(methods(describe)))              # 5
# methods(describe) prints the signatures; each line is one method.

# Dispatch is not only cosmetic. Two arguments of different types can select
# different arithmetic, which is exactly what we want for real and complex
# representations of the same physical quantity.

# There is also a failure mode worth seeing. When two methods can both claim a
# call, Julia refuses to choose and the call fails where it is made:
combine(x::Int, y::Number) = "method 1"
combine(x::Number, y::Int) = "method 2"

println(combine(3, 4.5))                        # method 1  (only the first fits)
println(combine(3.5, 4))                        # method 2  (only the second fits)
println(combine(3, 4))                          # MethodError: combine(::Int64, ::Int64) is ambiguous.
# For the call (3, 4) both methods fit: the first in x, the second in y. Julia
# does not fall back on method order and does not convert 4 to 4.5. A third
# method combine(x::Int, y::Int) would settle it and end the ambiguity.

# --- 7. One function for real arguments, another for complex ---------------------
#
# Intensity is an amplitude squared. For a real field that is a^2; for a complex
# amplitude it is |z|^2 = z * conj(z). One name, two methods, and dispatch picks
# the arithmetic from the type of the argument.
intensity(a::Real) = a^2
intensity(z::Complex) = abs2(z)
intensity(amps::Vector) = sum(intensity.(amps))
# Note that this particular example could be written as a single method, because abs2 works for both real and complex numbers.
# But the two methods are clearer, and they allow different documentation for the two cases.

println(intensity(2.0))                         # 4.0
println(intensity(2.0im))                       # 4.0  (same intensity)
println(intensity(1.0 + 1.0im))                 # 2.0
println(intensity([1.0, 2.0, 3.0]))             # 14.0

# Notice how the last method uses broadcasting (the dot) to apply the first two methods to each element of the vector. The sum then adds the results.

# --- 8. Tuples: packing and unpacking --------------------------------------------

# A tuple groups values of any types, in order, and cannot be changed after it is
# built. Parentheses with commas pack it.
a_tuple = (1, 2.0, "three")
point = (3.0, 4.0)
println(point)                                  # (3.0, 4.0)
println(typeof(point))                          # Tuple{Float64, Float64}

# Unpacking assigns the parts to names in one statement:
x, y = point
println(x)                                      # 3.0
println(y)                                      # 4.0

# Unpacking is the standard way to swap two values, because the right side is
# evaluated before either name is rebound:
# notice that () is not needed on the right side, because the comma is enough to make a tuple.
a, b = 1, 2
a, b = b, a
println((a, b))                                 # (2, 1)

# A function can return several results as a tuple, and the caller unpacks them.
function range_of(v)
    return minimum(v), maximum(v)
end
lo, hi = range_of([3.0, 1.0, 4.0, 1.5])
println(lo, " ", hi)                            # 1.0 4.0

# Tuples may mix types, which makes them convenient for labelled records:
particle = ("electron", 9.11e-31, -1)
name, mass, charge = particle
println(name, " ", mass, " ", charge)           # electron 9.11e-31 -1

# A one-element tuple needs the trailing comma:
one = (5,)
println(typeof(one))                            # Tuple{Int64}

# A comprehension can build tuples too, which packs a small record per element:
numbers_and_squares = [(n, n^2) for n in 1:6]
println(numbers_and_squares)                    # [(1, 1), (2, 4), (3, 9), (4, 16), (5, 25), (6, 36)]

# Two loops without a comma between them give a flat vector of pairs, not a
# matrix: the first loop is the outer one.
ij_pairs = [(i, j) for i in 1:3 for j in 1:2]
println(ij_pairs)                               # [(1, 1), (1, 2), (2, 1), (2, 2), (3, 1), (3, 2)]

# A condition inside the comprehension keeps only some of the pairs:
even_sum_pairs = [(i, j) for i in 1:3 for j in 1:3 if iseven(i + j)]
println(even_sum_pairs)                         # [(1, 1), (1, 3), (2, 2), (3, 1), (3, 3)]

# --- 9. Tuples in a loop: Fibonacci numbers --------------------------------------

# The swap from the last section is the heart of this calculation: each new pair
# must be built from the previous pair, which is exactly what tuple unpacking
# gives us.
"""
    fibonacci(n::Integer)

Return the nth Fibonacci number, with F(0) = 0 and F(1) = 1. Negative n is
rejected, and the result is a BigInt so that large n does not overflow.
"""
function fibonacci(n::Integer)
    if n < 0
        throw(ArgumentError("n must be nonnegative"))
    end
    a, b = big(0), big(1)
    for _ in 1:n
        a, b = b, a + b            # both new values use the previous a and b
    end
    return a
end

for n in 1:10
    println("F($n) = $(fibonacci(n))")
end
# 1, 1, 2, 3, 5, 8, 13, 21, 34, 55

println(fibonacci(10))                          # 55
println(fibonacci(0), " ", fibonacci(1), " ", fibonacci(2))  # 0 1 1

# big() gives arbitrary-precision integers. With ordinary Int64 arithmetic the
# sequence overflows at F(93), and every later value comes out with the wrong
# sign. The loop is the same; only the type of the starting values changed.
println("F(2000) has ", length(digits(fibonacci(2000))), " decimal digits")

# --- 10. map and filter -----------------------------------------------------------

# map applies a function to every element and returns a new collection. It is the
# functional counterpart of the comprehension from Week 5.
v = [1, 2, 3, 4]
println(map(square_it, v))                      # [1, 4, 9, 16]
println(map(x -> x^2, [1, 2, 3, 4]))            # [1, 4, 9, 16]
println([x^2 for x ∈ [1, 2, 3, 4]])            # [1, 4, 9, 16] (same thing)  \in to get the ∈ symbol, just because it nice :)
println(map(sqrt, (1.0, 4.0, 9.0)))             # (1.0, 2.0, 3.0) (a tuple in, a tuple out)

# With two collections, map walks them together:
println(map(+, [1, 2, 3], [10, 20, 30]))        # [11, 22, 33]

# filter keeps the elements for which the function returns true:
println(filter(isodd, v))                       # [1, 3]
println(filter(x -> x > 2, v))                  # [3, 4]
println([x for x ∈ v if x > 2])                 # [3, 4] (same thing)

# map and filter chain naturally:
println(filter(x -> x > 4, map(x -> 2x, v)))    # [6, 8]
println([2x for x ∈ v if 2x > 4])               # [6, 8] (same thing, but notice that 2x is required twice)

# Choose by what you are expressing: map says "transform every element", and
# filter says "keep some of them". A comprehension is often shorter when both
# happen at once.

# filter! makes the same selection in place: it throws away the failing elements
# from the vector itself and returns that same vector. The ! is the convention
# from Week 5, a warning that the argument is changed.
w = [1, 2, 3, 4, 5, 6]
same_vector = w
filter!(iseven, w)
println(w)                                      # [2, 4, 6]
println(same_vector)                            # [2, 4, 6]  (the same vector)
# filter(iseven, w) would have returned a new vector and left w alone.

# --- 11. Piping: a chain written in the order it happens -------------------------

# A nested call is read from the inside out. The pipe operator |> moves the value
# from left to right instead: x |> f means exactly f(x), and the chain reads in
# the order the calculation happens.
println(3 |> sqrt)                              # 1.7320508075688772
println(3 |> sqrt |> round)                     # 2.0
println(round(sqrt(3)))                         # 2.0  (the same, inside out)

# more examples:
speeds = [3.0, 8.0, 12.0, 4.5]                  # m/s
energy_per_kg(speed) = speed^2 / 2              # J/kg
println(speeds |> maximum |> energy_per_kg)     # 72.0

# Piping only fills the first argument. What if we need to fill the second? We can use an anonymous function to wrap the call:
# Suppose we have:
kinetic_energy(mass, speed) = mass * speed^2 / 2
mass = 2.0
speeds = [3.0, 8.0, 12.0, 4.5]
println( speeds |> maximum |> (v -> kinetic_energy(mass, v)))  # 144.0

# Another examples
fast(v) = filter(speed -> speed > 5.0, v)
squared(v) = map(speed -> speed^2, v)
println(speeds |> fast)                         # [8.0, 12.0]
println(speeds |> fast |> squared)              # [64.0, 144.0]
println(speeds |> fast |> squared |> sum)       # 208.0
# The same computation, with the calls nested:
println(sum(squared(fast(speeds))))             # 208.0

# occasionally a pipe is clearer than a nested call,
# especially when the chain is long.
# The following example is a contrived one, but it shows the idea:
println([1, 2, 3, 4] |> v->map(x -> x^2, v) |> v->filter(x -> x > 5,v) |> sum)  # 25
# compare with:
println(sum(filter(x -> x > 5, map(x -> x^2, [1, 2, 3, 4]))))  # 25

# An anonymous step needs parentheses, because -> binds more loosely than |>. The
# pipe itself never adds an argument: filter(predicate) alone has one argument
# and fails, so the collection has to enter through a named or anonymous step.
println(speeds |> (v -> filter(speed -> speed > 5.0, v)) |> sum)  # 20.0

# Use a pipe when a reader should follow the data through several steps. For two
# or three steps the nested form is usually clearer, and for arrays the
# comprehensions above often say it best.

# --- 12. One example, four ideas: two coherent waves -----------------------------
#
# Two waves arrive at the same detector. Each carries an amplitude and a phase,
# and the detector records intensity. We write a wave in whichever form is
# convenient, convert it to a complex amplitude, add the amplitudes, and square
# the sum. Intensities are normalized so that one wave alone has intensity 1.
#
# A wave can be given three ways: a real number is an amplitude with zero phase,
# a complex number already carries amplitude and phase, and a tuple packs them
# as (amplitude, phase).

phasor(a::Real) = complex(a)  # convert a real number to a complex number with zero phase
phasor(z::Complex) = z        # return the complex number as is
function phasor(wave::Tuple)  # convert a tuple of (amplitude, phase) to a complex number
    amplitude, phase = wave                    # unpack; phase in radians
    return amplitude * exp(im * phase)
end

# Amplitudes add, and the detector sees the intensity of their sum.

# If waves are given as (A1, phi1) and (A2, phi2), then the total amplitude is
# Z12 = A1 * exp(i * phi1) + A2 * exp(i * phi2)

# If waves are given as (R1, I1) and (R2, I2), then the total amplitude is
# Z12 = (R1 + R2) + i * (I1 + I2)

# and the intensity is I12 = |Z12|^2

function interference(wave1, wave2)
    total = phasor(wave1) + phasor(wave2)
    return abs2(total)
end

# convert two waves with zero phase, add them, and square the sum. The result is the intensity:
println(interference(1.0, 1.0))                 # 4.0  in phase: constructive
# convert two waves with opposite phase (described as complex numbers), add them, and square the sum.
# The result is the intensity:
println(interference(1.0, -1.0 + 0.0im))        # 0.0  opposite phase: destructive
# Now we describe the second wave as a tuple of amplitude and phase, add them, and square the sum. The result is the intensity:
println(round(interference(1.0, (1.0, pi / 2)); digits = 6))  # 2.0  quarter cycle

# Now scan the relative phase and keep only the nearly dark settings. map builds
# one record per phase, and each record is a tuple holding phase and intensity.
phases = range(0, 2π; length = 361)             # rad, one degree apart, equivalent to 0:2π/360:2π

samples = map(phase -> (phase, interference(1.0, (1.0, phase))), phases)

using Plots
plot(samples; xlabel = "phase (rad)", ylabel = "intensity", title = "Two equal amplitudes, varying relative phase", label = "interference pattern")

# filter keeps the records below 1% of the maximum intensity of 4.
dark = filter(sample -> sample[2] < 0.04, samples)
println(length(dark))                           # 23 of the 361 sampled phases
println(round(rad2deg(first(dark)[1]); digits = 1))  # 169.0
println(round(rad2deg(last(dark)[1]); digits = 1))   # 191.0

scatter!(dark; color = :red, label = "dark records")
