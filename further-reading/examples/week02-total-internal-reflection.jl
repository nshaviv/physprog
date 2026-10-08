# %% setup
using Plots
using Printf
gr()
default(size = (760, 420), linewidth = 2, legend = :topright)
println("Optics ready; angles measured from the interface normal unless stated.")

# %% classification
n1 = 1.50
n2 = 1.00
theta_i_deg = 50.0
q = n1 * sind(theta_i_deg) / n2
@printf("sin(theta_t) requested by Snell: %.6f\n", q)
if q > 1.0
    println("total internal reflection: no propagating transmitted ray")
elseif q == 1.0
    println("critical angle: transmitted ray is grazing")
else
    theta_t_deg = asind(q)
    @printf("refracted ray: theta_t = %.3f degrees\n", theta_t_deg)
end
theta_c_deg = asind(n2 / n1)
@printf("critical angle = %.3f degrees\n", theta_c_deg)

# %% refraction
theta_i_deg = 30.0
theta_t_deg = asind(n1 * sind(theta_i_deg) / n2)
@printf("30-degree incidence gives %.3f-degree transmission\n", theta_t_deg)
s = range(0.0, 1.0; length = 100)
p_rays = plot([-1.0, 1.0], [0.0, 0.0]; color = :black, label = "interface",
    xlabel = "x (arbitrary length unit)", ylabel = "z (same unit)", aspect_ratio = :equal)
plot!(p_rays, [0.0, 0.0], [-1.0, 1.0]; linestyle = :dash, color = :gray, label = "normal")
plot!(p_rays, -s .* sind(theta_i_deg), -s .* cosd(theta_i_deg); label = "incident path")
plot!(p_rays, s .* sind(theta_i_deg), -s .* cosd(theta_i_deg); label = "reflected path")
plot!(p_rays, s .* sind(theta_t_deg), s .* cosd(theta_t_deg); label = "transmitted path")
display(p_rays)

# %% evanescent
lambda0_um = 0.55
θ_deg = range(theta_c_deg + 0.01, 80.0; length = 1000)
kappa_per_um = (2pi / lambda0_um) .* sqrt.(n1^2 .* sind.(θ_deg) .^ 2 .- n2^2)
depth_um = 1.0 ./ kappa_per_um
kappa50 = (2pi / lambda0_um) * sqrt(n1^2 * sind(50.0)^2 - n2^2)
@printf("50 degrees: amplitude penetration depth = %.4f micrometres\n", 1 / kappa50)
z_um = range(0.0, 1.0; length = 501)
p_depth = plot(θ_deg, depth_um; label = "1/kappa", xlabel = "incidence (degrees)",
    ylabel = "amplitude depth (micrometres)", yscale = :log10)
p_field = plot(z_um, exp.(-kappa50 .* z_um); label = "field amplitude",
    xlabel = "distance into air (micrometres)", ylabel = "normalized value")
plot!(p_field, z_um, exp.(-2 .* kappa50 .* z_um); label = "squared amplitude")
display(plot(p_depth, p_field; layout = (1, 2), size = (960, 420)))

# %% acceptance
n_core = 1.48
n_clad = 1.46
n_external = 1.0
NA = sqrt(n_core^2 - n_clad^2)
alpha_max_deg = acosd(n_clad / n_core)
theta_accept_deg = asind(min(1.0, NA / n_external))
@printf("NA = %.4f; internal axial limit = %.3f degrees\n", NA, alpha_max_deg)
@printf("External acceptance half-angle = %.3f degrees\n", theta_accept_deg)
alpha_deg = 5.0
theta_wall_deg = 90.0 - alpha_deg
@printf("Chosen axial angle = %.1f; wall incidence = %.1f degrees\n", alpha_deg, theta_wall_deg)
println("Guided by strict TIR? ", theta_wall_deg > asind(n_clad / n_core))

# %% fiber
width_mm = 0.1
length_mm = 5.0
x_mm = range(0.0, length_mm; length = 5001)
unfolded_mm = x_mm .* tand(alpha_deg)
y_mm = width_mm / 2 .- abs.(mod.(unfolded_mm .+ width_mm / 2, 2 * width_mm) .- width_mm)
@printf("First wall hit: %.4f mm\n", width_mm / (2 * tand(alpha_deg)))
@printf("Axial distance between later wall hits: %.4f mm\n", width_mm / tand(alpha_deg))
p_fiber = plot(x_mm, y_mm; label = "ideal meridional ray", xlabel = "axial x (mm)",
    ylabel = "transverse y (mm)", ylim = (-0.07, 0.07))
hline!(p_fiber, [-width_mm / 2, width_mm / 2]; color = :black, label = "core boundaries")
display(p_fiber)

# %% checks
using Test
# The final semicolon hides the returned test object; its summary still prints.
@testset "Ray and wave limits" begin
    @test asind(n1 * sind(0.0) / n2) == 0.0
    @test isapprox(n1 * sind(theta_c_deg), n2; atol = 1e-14)
    @test isapprox(n1 * sind(30.0), n2 * sind(theta_t_deg); atol = 1e-14)
    @test isapprox(exp(-kappa50 * (1 / kappa50)), exp(-1); atol = 1e-14)
    @test maximum(abs.(y_mm)) <= width_mm / 2 + 1e-14
    @test isapprox(y_mm[1], 0.0; atol = 1e-14)
    @test theta_wall_deg > asind(n_clad / n_core)
    @test isapprox(n_external * sind(theta_accept_deg), NA; atol = 1e-14)
end;
