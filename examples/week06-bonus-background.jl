# Week 6 optional bonus background — phasors and two-wave interference.
# Supplied example; not a prerequisite for core work and not bonus submission code.
# Same-frequency, same-polarization coherent waves; phase is in radians.
# Amplitudes and intensity are normalized, with unit intensity for one unit wave.
# The detector averages over rapid oscillations; rapid relative-phase drift
# removes the cross term, outside this fixed-phase model.

# --- 1. One example, four ideas: two coherent waves -----------------------------
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
p = plot(first.(samples), last.(samples); xlabel = "phase (rad)",
    ylabel = "intensity", title = "Two equal amplitudes, varying relative phase",
    label = "interference pattern")

# filter keeps the records below 1% of the maximum intensity of 4.
dark = filter(sample -> sample[2] < 0.04, samples)
println(length(dark))                           # 23 of the 361 sampled phases
println(round(rad2deg(first(dark)[1]); digits = 1))  # 169.0
println(round(rad2deg(last(dark)[1]); digits = 1))   # 191.0

scatter!(p, first.(dark), last.(dark); color = :red, label = "dark records")
display(p)
