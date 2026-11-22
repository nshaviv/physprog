# Supplied local driver. Put your function in bonus07.jl beside this file.
# Plots runs locally; the numerical function itself does not import Plots.
include("bonus07.jl")
include("bonus07-plot.jl")

n = 1000
k = ones(n + 1)                  # N/m
k[301:1001] .= 0.5               # N/m
f = zeros(n)                    # N
f[500] = 1.0                    # N
result = chain_equilibrium(k, f)
display(plot_chain(result))
