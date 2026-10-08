using BenchmarkTools
using CSV
using DataFrames
using IJulia
using Optim
using OrdinaryDiffEq
using Plots
using PlotlyJS
using StableRNGs
using Unitful
using LinearAlgebra
using Random
using Statistics
using Test

@test VERSION >= v"1.12" && VERSION < v"1.13"
@test mean([1.0, 2.0, 3.0]) == 2.0
@test isapprox(2u"m" + 30u"cm", 2.3u"m")
@test rand(StableRNG(77641), UInt) == rand(StableRNG(77641), UInt)

mktempdir() do output_directory
    Plots.gr()
    static_plot = Plots.plot(0:2, (0:2) .^ 2; label="y = x^2")
    Plots.savefig(static_plot, joinpath(output_directory, "course-environment.png"))
    Plots.savefig(static_plot, joinpath(output_directory, "course-environment.pdf"))

    Plots.plotlyjs()
    interactive_plot = Plots.plot(0:2, (0:2) .^ 2; label="y = x^2")
    Plots.savefig(interactive_plot, joinpath(output_directory, "course-environment.html"))

    @test isfile(joinpath(output_directory, "course-environment.png"))
    @test isfile(joinpath(output_directory, "course-environment.pdf"))
    @test isfile(joinpath(output_directory, "course-environment.html"))
end

println("Course Julia environment verified.")
