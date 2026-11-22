# Supplied plotting helper; no equilibrium solution is included.
using Plots

function plot_chain(result; path="bonus07-chain.png")
    n = length(result.displacements)
    p1 = plot(
        0:(n + 1),
        [0.0; result.displacements; 0.0];
        xlabel="block / support index",
        ylabel="displacement (m)",
        label="equilibrium",
        linewidth=2,
    )
    p2 = plot(
        1:(n + 1),
        result.extensions;
        xlabel="spring index",
        ylabel="signed extension (m)",
        label="extension",
        linewidth=2,
    )
    p = plot(p1, p2; layout=(2, 1), size=(850, 650))
    savefig(p, path)
    return p
end
