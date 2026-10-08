# %% setup
using Plots
using Printf
gr()
default(size = (760, 420), linewidth = 2, legend = :topright)
println("Plots ready; coordinates in metres, time in seconds.")

# %% scalar
A = 0.02
B = 0.01
omega_x = 2pi
omega_y = 2pi
delta = 0.0
t = 0.25
x = A * cos(omega_x * t + delta)
y = B * sin(omega_y * t)
@printf("t = %.2f s: x = %.5f m, y = %.5f m\n", t, x, y)

# %% sampling
times = range(0.0, 1.0; length = 501)
xs = A .* cos.(omega_x .* times .+ delta)
ys = B .* sin.(omega_y .* times)
@printf("%d samples; dt = %.4f s\n", length(times), step(times))
p_time = plot(times, xs; label = "x(t)", xlabel = "t (s)", ylabel = "position (m)")
plot!(p_time, times, ys; label = "y(t)")
display(p_time)
p_orbit = plot(xs, ys; label = "equal frequencies", xlabel = "x (m)",
    ylabel = "y (m)", aspect_ratio = :equal)
display(p_orbit)

# %% phase
delta = pi / 4
xs = A .* cos.(omega_x .* times .+ delta)
ys = B .* sin.(omega_y .* times)
X = xs ./ A
Y = ys ./ B
ellipse_residual = X .^ 2 .+ Y .^ 2 .+ 2 .* X .* Y .* sin(delta) .- cos(delta)^2
@printf("Largest ellipse-equation residual: %.2e\n", maximum(abs.(ellipse_residual)))
p_phase = plot(xs, ys; label = "delta = pi/4", xlabel = "x (m)",
    ylabel = "y (m)", aspect_ratio = :equal)
plot!(p_phase, A .* cos.(omega_x .* times .+ pi / 2), ys; label = "delta = pi/2")
display(p_phase)

# %% closure
omega_x = 3 * 2pi
omega_y = 2 * 2pi
delta = 0.3
times = range(0.0, 1.0; length = 1501)
xs = A .* cos.(omega_x .* times .+ delta)
ys = B .* sin.(omega_y .* times)
vx = -A .* omega_x .* sin.(omega_x .* times .+ delta)
vy = B .* omega_y .* cos.(omega_y .* times)
@printf("Position closure error: %.2e m\n", hypot(xs[end] - xs[1], ys[end] - ys[1]))
@printf("Velocity closure error: %.2e m/s\n", hypot(vx[end] - vx[1], vy[end] - vy[1]))
display(plot(xs, ys; label = "3:2, T = 1 s", xlabel = "x (m)",
    ylabel = "y (m)", aspect_ratio = :equal))

# %% detuning
omega_x = 1.01 * 2pi
omega_y = 2pi
delta = 0.0
short_t = range(0.0, 1.0; length = 1001)
long_t = range(0.0, 100.0; length = 100001)
@printf("Relative-phase cycle: %.1f s\n", 2pi / abs(omega_x - omega_y))
p_short = plot(A .* cos.(omega_x .* short_t), B .* sin.(omega_y .* short_t);
    label = "first second", xlabel = "x (m)", ylabel = "y (m)", aspect_ratio = :equal)
p_long = plot(A .* cos.(omega_x .* long_t), B .* sin.(omega_y .* long_t);
    label = "100 seconds", xlabel = "x (m)", ylabel = "y (m)", aspect_ratio = :equal)
display(plot(p_short, p_long; layout = (1, 2), size = (960, 400)))

# %% aliasing
coarse_t = range(0.0, 1.0; length = 5)
fine_t = range(0.0, 1.0; length = 1001)
p_alias = plot(A .* cos.(2pi .* fine_t), B .* sin.(2pi .* fine_t);
    label = "dense model", xlabel = "x (m)", ylabel = "y (m)", aspect_ratio = :equal)
plot!(p_alias, A .* cos.(2pi .* coarse_t), B .* sin.(2pi .* coarse_t);
    marker = :circle, label = "4 intervals")
display(p_alias)

# %% checks
using Test
# The final semicolon hides the returned test object; its summary still prints.
@testset "Oscillator geometry" begin
    @test isapprox(x, 0.0; atol = 1e-16)
    @test isapprox(y, B; atol = 1e-16)
    @test maximum(abs.(ellipse_residual)) < 1e-12
    @test hypot(xs[end] - xs[1], ys[end] - ys[1]) < 1e-12
    @test hypot(vx[end] - vx[1], vy[end] - vy[1]) < 1e-12
    m = 0.1
    energy = 0.5 .* m .* (vx .^ 2 .+ vy .^ 2) .+
        0.5 .* m .* ((3 * 2pi)^2 .* xs .^ 2 .+ (2 * 2pi)^2 .* ys .^ 2)
    expected_energy = 0.5 * m * ((3 * 2pi)^2 * A^2 + (2 * 2pi)^2 * B^2)
    @test maximum(abs.(energy .- expected_energy)) < 1e-12
end;
