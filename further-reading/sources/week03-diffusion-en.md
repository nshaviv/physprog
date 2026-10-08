# 3. Random walks: how randomness produces a diffusion law

**Optional self-study · approximately 120–160 minutes.** This chapter is unexamined and is not a prerequisite for later core work. We assume Week 3 loops, vectors, and means; probability, ensemble averaging, diffusion, and a continuum equation are introduced here. It is independent of the optional bonus. No student-defined functions are required.

## 3.1 One unpredictable particle, a predictable cloud

A drop of dye spreads even when we cannot follow every molecular collision. A suspended microscopic particle also wanders under irregular impacts from surrounding molecules. Can a model with unpredictable individual steps nevertheless predict how far a cloud spreads?

We begin with a deliberately simple one-dimensional walk. This is not a literal simulation of every molecular impact. It is a model for the cumulative displacement over a chosen time interval, useful when directional memory has decayed and the environment is approximately uniform.

> **Physics — the discrete model and its regime.** At times $t_N=N\Delta t$, a particle jumps by $\xi_i=+\ell$ or $-\ell$ with equal probability. Rightward is positive, $\ell>0$ is a length, $\Delta t>0$ is a time, and the initial position is zero. Steps are independent, have no directional bias, and occur in an unbounded homogeneous medium. There are no interactions between walkers or absorbing walls. Short-time inertial motion, correlated steps, drift, or confinement can invalidate the model. After one step the mean is zero and the mean squared displacement is $\ell^2$.

## 3.2 Probability and expectation, from scratch

A random variable assigns a number to each possible outcome. Its **expectation** is a probability-weighted average. Our step has two outcomes, so

$$\langle\xi\rangle=\tfrac12\ell+\tfrac12(-\ell)=0,
\qquad \langle\xi^2\rangle=\tfrac12\ell^2+\tfrac12\ell^2=\ell^2.$$

Angle brackets denote an ideal average over repetitions of the same experiment. The **variance** is the average squared deviation from the mean:

$$\operatorname{Var}(\xi)=\langle(\xi-\langle\xi\rangle)^2\rangle
=\langle\xi^2\rangle-\langle\xi\rangle^2.$$

Independence means that knowing one step does not change probabilities for another. It implies $\langle\xi_i\xi_j\rangle=\langle\xi_i\rangle\langle\xi_j\rangle=0$ for $i\ne j$. Independence is stronger than a zero mean; a sequence that alternates deterministically between left and right can have zero mean without diffusing.

After $N$ steps,

$$x_N=\sum_{i=1}^N\xi_i,\qquad
\langle x_N\rangle=0.$$

Squaring creates diagonal terms $\xi_i^2$ and cross terms $\xi_i\xi_j$. The cross terms vanish in expectation, leaving

$$\boxed{\langle x_N^2\rangle=N\ell^2.}$$

We define the one-dimensional diffusion coefficient $D=\ell^2/(2\Delta t)$, which has units length squared per time. Then

$$\boxed{\langle x^2(t)\rangle=2Dt,\qquad x_{\rm rms}=\sqrt{2Dt}.}$$

> **Mathematics — square the displacement, not the mean.** $\langle x^2\rangle$ is not $\langle x\rangle^2$. A symmetric cloud can have mean zero and a growing width. The RMS displacement grows as $\sqrt{t}$, whereas constant-velocity ballistic displacement grows as $t$. Four times as long produces twice the diffusive RMS distance, not four times.

## 3.3 A reproducible random step

`Random` supplies random draws. `StableRNGs` supplies a generator with a reproducible stream for its documented interface. `StableRNG(seed)` creates a local generator; the integer seed identifies its starting state. Reusing the seed at the start of a complete experiment repeats that experiment. Recreating the generator inside every step would instead repeat the same draw and destroy independence. `Statistics` provides `mean` and `var`; the remaining setup selects plotting and formatting.

<!-- code: setup -->

`rand(rng)` gives a pseudorandom number between zero and one. Values below 0.5 choose left; all other values choose right. The equal lengths of these subintervals give equal probabilities. This first tiny example lets us inspect one decision before using it repeatedly.

<!-- code: coin -->

Computers use deterministic algorithms to imitate independent samples. A fixed seed is useful for debugging; it does not make a finite sample equal to its mathematical expectation. We will also calculate the scale of the expected sampling fluctuations.

## 3.4 One trajectory

`zeros(N + 1)` reserves the starting position plus $N$ later positions. Because Julia starts indices at one, `position_um[k + 1]` holds the position after step $k$. Each new value is the previous position plus one jump. The loop implements the sum in the derivation without storing every jump separately. We choose $\ell=1\ \mu$m and $\Delta t=0.1$ s, giving $D=5\ \mu\mathrm{m}^2/\mathrm{s}$.

<!-- code: one_walk -->

The plotted segments connect observations at discrete times; the jump model does not prescribe a physical velocity along those straight segments. Its final displacement need not be zero. Nor should a single curve $x(t)^2$ be expected to follow $2Dt$ smoothly: that law refers to a repeated-experiment average.

## 3.5 An ensemble: many copies of the same experiment

We now evolve $M=10000$ independent walkers. A vector stores their current positions. The outer loop advances time and the inner loop updates each walker once. We store the mean and the mean square after every update:

$$\bar{x}_N=\frac1M\sum_{j=1}^M x_N^{(j)},\qquad
\widehat{\mathrm{MSD}}_N=\frac1M\sum_{j=1}^M (x_N^{(j)})^2.$$

The superscript labels a walker, not a power. `positions_um .^ 2` squares entries before averaging. `eachindex` visits all valid positions. The code retains two short time series and one current ensemble rather than a large matrix of all trajectories. The expression `[msd_um2 theory_um2]` supplies two plotting columns; it is a supplied plotting convenience, not a new core matrix exercise.

To judge agreement, first calculate expected sampling uncertainty. Independence of walkers gives

$$\mathrm{SE}(\bar{x}_N)=\ell\sqrt{N/M}.$$

For the mean square we need a fourth moment. In expanding $x_N^4$, only terms with even powers of every independent zero-mean step survive. There are $N$ terms with four equal indices and $6\binom{N}{2}$ paired terms. Hence

$$\langle x_N^4\rangle=(3N^2-2N)\ell^4,
\quad\operatorname{Var}(x_N^2)=2N(N-1)\ell^4,$$

and averaging $M$ independent walkers gives

$$\mathrm{SE}(\widehat{\mathrm{MSD}}_N)=\ell^2\sqrt{\frac{2N(N-1)}{M}}.$$

At $N=200$, the expected mean square is $200\ \mu\mathrm{m}^2$, and its standard error is about $2.82\ \mu\mathrm{m}^2$. We should demand statistical agreement, not exact equality.

<!-- code: ensemble -->

The ensemble curve should fluctuate around the line. It is still random, even if visually close. Increasing the number of walkers by four should halve typical sampling errors. Increasing the number of steps alone does not create additional independent walkers.

> **Check — correlated time points.** Successive MSD values share the same walkers and their previous histories. Their errors are correlated. Treating every time point as an independent observation in a straight-line fit gives misleading uncertainty estimates. A straight line can be useful descriptively; independent repeated ensembles are a better route to assessing uncertainty in its slope.

## 3.6 Why the distribution becomes Gaussian

If $r$ of $N$ steps are rightward, then $x=(2r-N)\ell$. There are $\binom Nr$ ways to choose those steps, each with probability $2^{-N}$:

$$P\{x_N=(2r-N)\ell\}=\binom Nr2^{-N}.$$

For large $N$, many independent bounded increments produce an approximately Gaussian central distribution. With variance $N\ell^2=2Dt$, the continuum density is

$$p(x,t)=\frac{1}{\sqrt{4\pi Dt}}\exp\left(-\frac{x^2}{4Dt}\right),\qquad t>0.$$

A density has units inverse length; its integral, not its height, is a probability. There is also a discrete subtlety: after even $N$ only even multiples of $\ell$ are occupied, so the spacing between allowed positions is $2\ell$. To compare with a density, divide each occupied-bin count by $M(2\ell)$.

The code below counts each allowed endpoint. `zeros(Int, ...)` makes integer counters. The inverse coordinate mapping converts an endpoint to its bin index; `round(Int, ...)` gives that integer index. `+= 1` adds one. `bar` draws the bins and `plot!` overlays the continuum prediction. We plot only the central range but normalize using **all** endpoints.

<!-- code: distribution -->

The bars need not sit exactly on the Gaussian. Finite $M$ adds statistical fluctuations; finite $N$ leaves a lattice distribution; the Gaussian has tails beyond the discrete walk's strict bound $|x|\leq N\ell$. The approximation is most useful centrally when many steps have occurred.

## 3.7 From a walk to a differential equation

Let $p(x,t)$ be a smooth approximation to the density on scales larger than the step. To arrive at $x$ next, a walker must have been at $x-\ell$ and stepped right, or at $x+\ell$ and stepped left. Conservation of probability gives

$$p(x,t+\Delta t)=\tfrac12p(x-\ell,t)+\tfrac12p(x+\ell,t).$$

Taylor expansion means approximating nearby values by derivatives at the current point. To leading orders the left side is $p+\Delta t\,\partial_t p$, and the right side is $p+(\ell^2/2)\partial_x^2p$: the odd spatial derivatives cancel. Subtract $p$ and divide by $\Delta t$ to obtain

$$\boxed{\frac{\partial p}{\partial t}=D\frac{\partial^2p}{\partial x^2}.}$$

This **diffusion equation** describes a macroscopic density. It does not say a single particle follows a differentiable curve. The Gaussian above solves it on an infinite line for an initially localized unit probability, with total integral one. A narrow finite initial cloud is instead convolved with this spreading Gaussian.

> **Mathematics — the continuum limit holds $D$ fixed.** Decreasing both step length and step time arbitrarily changes the physics. To halve $\ell$ while preserving $D$, divide $\Delta t$ by four. The limit takes many increasingly small steps at fixed $\ell^2/(2\Delta t)$, with the density varying slowly across individual steps. At $t=0$ the ideal point-source density is singular; do not evaluate the Gaussian formula there.

## 3.8 Estimating diffusion, and adding a drift

At a fixed nonzero time we can estimate $D$ from $\widehat{\mathrm{MSD}}/(2t)$, with standard error inherited from the mean square. This estimator is unbiased for our zero-start, unbiased walk. It is not automatically appropriate for measurement error or a particle under a force.

If the probability of a right step becomes $p_r$, then

$$\mu_\xi=(2p_r-1)\ell,\qquad \sigma_\xi^2=4p_r(1-p_r)\ell^2.$$

The drift speed is $v=\mu_\xi/\Delta t$ and $D_{\rm bias}=\sigma_\xi^2/(2\Delta t)$. Consequently,

$$\langle x\rangle=vt,\quad \operatorname{Var}(x)=2D_{\rm bias}t,
\quad \langle x^2\rangle=2D_{\rm bias}t+(vt)^2.$$

<!-- code: inference -->

The biased second moment grows partly as $t^2$. Using it directly as $2Dt$ would mistake drift for stronger diffusion. The numerical biased values above are analytic predictions, explicitly labelled as such; the guided extension below asks us to simulate them independently.

## 3.9 Auditing the experiment

`diff` subtracts successive entries, so it checks jump sizes. `all` requires a condition at every entry. `var(...; corrected = false)` uses denominator $M$, matching the exact finite-ensemble identity $\overline{x^2}-\bar{x}^2$. The default corrected variance instead uses $M-1$ for unbiased estimation of the population variance. Tests are grouped using `@testset`; floating-point identities use `isapprox` with a small absolute tolerance.

<!-- code: checks -->

The two five-standard-error bounds are broad diagnostic checks for this fixed-seed experiment, not universal deterministic laws or proof that a random generator is good. The normalization, step size, and moment identity checks test different mistakes from the final agreement with diffusion theory.

## 3.10 Guided investigation and self-test

1. Derive the exact endpoint probabilities after two steps. Calculate the mean, mean square, and fourth moment; compare with the general formulas.
2. Repeat the ensemble with $M=2500$ and $10000$, using several different seeds. Keep $N$, $\ell$, and $\Delta t$ fixed. Compare errors scaled by their predicted standard errors, rather than selecting the run that looks best.
3. Halve $\ell$ and divide $\Delta t$ by four. Multiply the step count by four to keep the same final physical time. Compare endpoint width with the original experiment and explain the difference between lattice resolution and sampling noise.
4. Implement rightward probability 0.6 by choosing left when the random draw is below 0.4. Record mean, variance, and raw second moment and compare all three with the predictions above.
5. Suppose we accidentally reset the generator inside every step. Predict the resulting trajectory and the time dependence of its squared displacement. Explain which assumption in the derivation fails.
6. **Open extension:** add reflecting walls at $\pm L$. Explain why indefinitely linear growth of the mean square is now impossible and which boundary conditions the continuum model needs.

**Deliverable for yourself:** one trajectory, an ensemble MSD graph, a normalized endpoint distribution, a seed/ensemble-size comparison table, and a paragraph distinguishing model error, discretization, and finite-sample fluctuations. The solutions companion supplies reasoning and numerical benchmarks.

**Summary.** Independent zero-mean increments yield linear growth of variance. Ensemble averages reveal a law obscured in one realization; their uncertainty is quantifiable. A continuum limit connects a discrete stochastic algorithm to a differential equation, while drift requires separating variance from raw second moment.

**Further reading:** [Julia Random documentation](https://docs.julialang.org/en/v1/stdlib/Random/); [StableRNGs documentation](https://github.com/JuliaRandom/StableRNGs.jl). For Brownian motion and the diffusion equation, consult a statistical-physics text; all equations needed for this investigation are derived here.
