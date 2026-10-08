# Further explorations: worked answers

[Reader and notebook index](README.md). These answers are for optional self-study,
not assessment. Try the questions before reading their answers. Numerical values
below are analytic benchmarks or rounded values from the supplied executed examples;
randomized investigations have no single required realization.

## 1. Lissajous curves

### 1. Phase predictions

At time zero, $x=A\cos\delta$ and $y=0$. For the four proposed phases:

| $\delta$ | Starting point | Shape |
|---|---|---|
| $0$ | $(A,0)$ | Axis-aligned ellipse |
| $\pi/4$ | $(A/\sqrt2,0)$ | Tilted ellipse |
| $\pi/2$ | $(0,0)$ | $y=-(B/A)x$ |
| $-\pi/2$ | $(0,0)$ | $y=(B/A)x$ |

The signs follow from $\cos(u+\pi/2)=-\sin u$ and
$\cos(u-\pi/2)=\sin u$. The line case passes repeatedly through the origin;
that point alone does not identify a complete-state return. Velocities matter.

### 2. Period table

With $f_y=1$ Hz and both amplitudes nonzero:

| $f_x:f_y$ | $f_x$ (Hz) | Fundamental state period (s) | Cycles $(x,y)$ |
|---|---:|---:|---|
| 1:1 | 1 | 1 | (1,1) |
| 2:1 | 2 | 1 | (2,1) |
| 3:2 | 1.5 | 2 | (3,2) |

The main worked 3:2 example instead uses $f_x=3$ Hz, $f_y=2$ Hz, so its period
is **one** second. A ratio fixes the relative timing, not the absolute period.
For each table row substitute the period in both position and velocity formulas.
Each phase has advanced by an integer multiple of $2\pi$.

### 3. Doubling an amplitude

Width $2A$ doubles; height $2B$ and both periods stay unchanged.
$E_x=\tfrac12m\omega_x^2A^2$ increases by four. Total energy becomes
$4E_x+E_y$, which is generally not four times the old total. This distinguishes
geometric scaling from an energy scaling law.

### 4. Coarse sampling

For the table's 3:2 case, sampling every 0.5 s gives only 4/3 samples per
fast $x$ cycle and two per $y$ cycle. With the main example's frequencies, it
gives only 2/3 samples per $x$ cycle and one per $y$ cycle: the sampled $y$
coordinate can appear frozen at zero. A full-state return at the interval's
end still occurs because the true phases complete whole cycles. Interior
geometry is poorly resolved. At 0.002 s spacing, either choice is densely sampled.

### 5. Irrational and rational models

$\sqrt2$ is mathematically irrational, so the ideal full state does not repeat.
$1.414=707/500$ is rational; with $f_y=1$ Hz it has period 500 s. Thus neither
the 10 s nor the 100 s plot spans that rational model's complete period.
Report the plotted interval, timestep, and recurrence tolerance. “Did not return
within 100 seconds at our tolerance” is justified; “proved irrational” is not.

## 2. Total internal reflection

### 1. Glass-to-air table

For $n_1=1.5$ and $n_2=1.0$:

| Incidence | $q=1.5\sin\theta_i$ | Result |
|---|---:|---|
| $0^\circ$ | 0 | Transmission at $0^\circ$ |
| $30^\circ$ | 0.75 | Transmission at approximately $48.59^\circ$ |
| $40^\circ$ | approximately 0.9642 | Transmission at approximately $74.62^\circ$ |
| $50^\circ$ | approximately 1.1491 | TIR; no real transmitted-ray angle |

The critical angle is approximately $41.81^\circ$. Substituting each transmitted
angle in $n_2\sin\theta_t$ recovers the corresponding $n_1\sin\theta_i$.
Below critical incidence, “transmission” does not mean zero reflection.

### 2. Reversing the interface

From air into glass, $q=(1/1.5)\sin\theta_i\leq2/3<1$ for every permitted
incidence. A propagating transmitted direction always exists. Attempting
$\arcsin(1.5)$ would misuse a critical-angle formula whose prerequisite is
$n_1>n_2$.

### 3. Wavelength and penetration

At fixed indices and incidence, $\kappa\propto1/\lambda_0$, so $d=1/\kappa$
doubles when wavelength doubles. For the worked $50^\circ$ case the amplitude
depth changes from about $0.1547\ \mu$m at $0.55\ \mu$m wavelength to
$0.3094\ \mu$m at $1.10\ \mu$m. The squared-amplitude e-folding lengths
are half these depths. This prediction assumes the refractive indices do not
change with wavelength; real material dispersion can modify it.

### 4. Fiber launch angles

For $n_{\rm core}=1.48$ and $n_{\rm clad}=1.46$, the internal axial limit is
approximately $9.430^\circ$ and the wall critical angle about $80.570^\circ$.

- $\alpha=0^\circ$: a straight axial ray, with no side-wall encounters.
- $\alpha=5^\circ$: wall incidence $85^\circ$, above critical; ideal TIR guiding.
- $\alpha=12^\circ$: wall incidence $78^\circ$, below critical; light can leak
  into the cladding. A perfectly folded confined line would misrepresent it.

For the guided $5^\circ$ ray in a 0.1 mm core, the first wall hit is about
0.5715 mm from the entrance and later hits are about 1.1430 mm apart.
The acceptance half-angle outside the fiber in air is approximately
$14.033^\circ$; it is distinct from the internal axial limit.

### 5. Weak index contrast

$$\mathrm{NA}^2=(n_{\rm core}-n_{\rm clad})(n_{\rm core}+n_{\rm clad})
=\Delta n(2n_{\rm core}-\Delta n).$$

For $\Delta n\ll n_{\rm core}$, $\mathrm{NA}\simeq\sqrt{2n_{\rm core}\Delta n}$.
The acceptance cone collapses as the contrast vanishes; a uniform medium has no
index boundary to provide this mechanism of confinement.

### 6. Bends

A bent wall has a changing normal relative to the ray, so a launch that met the
straight-wall critical-angle condition may encounter a subcritical incidence.
Quantitative loss also requires wave and geometry information; it cannot be
deduced solely from the entrance NA. The ideal straight-guide assumption has failed.

## 3. Random walks and diffusion

### 1. Two steps exactly

The outcomes $-2\ell,0,+2\ell$ have probabilities $1/4,1/2,1/4$.
Thus $\langle x\rangle=0$, $\langle x^2\rangle=2\ell^2$, and
$\langle x^4\rangle=8\ell^4$. The general fourth-moment expression gives
$(3\cdot2^2-2\cdot2)\ell^4=8\ell^4$ as required. This is an exact small
enumeration, independent of any random generator.

### 2. Changing ensemble size

At $N=200$ and $\ell=1\ \mu$m, the standard errors for $M=2500$ are
$\mathrm{SE}(\bar{x})\simeq0.2828\ \mu$m and
$\mathrm{SE}(\widehat{\mathrm{MSD}})\simeq5.6427\ \mu\mathrm{m}^2$.
At $M=10000$ they halve to $0.1414$ and $2.8213$ in the same units.
For each run record the seed, $M$, mean, MSD, and standardized deviations
$\bar{x}/\mathrm{SE}(\bar{x})$ and $(\widehat{\mathrm{MSD}}-200)/\mathrm{SE}(\widehat{\mathrm{MSD}})$.
A particular larger sample need not be closer than a particular smaller one;
the prediction concerns repeated-run spread.

The supplied seed produces MSD $202.6884\ \mu\mathrm{m}^2$, about 0.95 standard
errors above theory, and $\bar{x}=0.0062\ \mu$m. The endpoint estimate
$D=5.0672\ \mu\mathrm{m}^2/\mathrm{s}$ is correspondingly about 0.95 standard
errors above 5. These are observed benchmark values, not values to force other seeds to match.

### 3. A continuum refinement at fixed physics

Use $\ell'=0.5\ \mu$m, $\Delta t'=0.025$ s and $N'=800$.
Then $D'=5\ \mu\mathrm{m}^2/\mathrm{s}$, $t'=20$ s, and the predicted final
MSD stays $200\ \mu\mathrm{m}^2$. The allowed endpoint spacing decreases from
2 to 1 micrometre. The lattice approximation improves; finite-ensemble noise
does not disappear because $M$ has not increased.

### 4. Bias

Choose left for draws below 0.4 and right otherwise, in **both** walk loops if
comparing single and ensemble paths. Keep one initialized generator outside the
loops. At $p_r=0.6$, $\mu_\xi=0.2\ \mu$m and $\sigma_\xi^2=0.96\ \mu\mathrm{m}^2$.
For 200 steps the predicted mean is $40\ \mu$m, variance $192\ \mu\mathrm{m}^2$,
and raw second moment $1792\ \mu\mathrm{m}^2$. The drift speed is
$2\ \mu\mathrm{m}/\mathrm{s}$ and diffusion around the drifting centre is
$4.8\ \mu\mathrm{m}^2/\mathrm{s}$. Measure the ensemble variance with denominator
$M$ when checking the finite-sample moment identity. The original unbiased
statistical tests must be replaced by checks of these new predictions.

### 5. Resetting the generator

Every step reuses the same first draw and hence the same direction. The path is
$x_N=\pm N\ell$, and $x_N^2=N^2\ell^2\propto t^2$. Even if different walkers
were assigned opposite fixed directions, their mean could cancel while their
mean square remained ballistic. The independent-increment cross terms no longer
vanish; zero ensemble mean alone does not establish diffusion.

### 6. Reflecting walls

Confinement gives $x^2\leq L^2$, hence the MSD is bounded. For the continuum
model the probability current is $J=-D\partial_xp$. Reflecting walls impose
$J(\pm L,t)=0$, equivalently $\partial_xp(\pm L,t)=0$ for constant positive $D$.
The stationary continuum density is $1/(2L)$, with second moment
$\int_{-L}^{L}x^2/(2L)\,dx=L^2/3$. A discrete walk requires a stated reflection
rule and may retain parity effects; it should not silently be treated as already
equal to this smooth long-time limit.
