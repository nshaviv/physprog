# 2. Total internal reflection: from a ray decision to a wave field

**Optional self-study · approximately 100–140 minutes.** This chapter is unexamined, is not a prerequisite, and is separate from the extra-credit complex-phasor bonus. We assume scalar arithmetic, degree trigonometry, and `if` branches. We explain the supplied sampling and plotting expressions locally. Wave vectors, evanescent decay, and numerical aperture are new enrichment concepts.

## 2.1 Can light reach a boundary and stay inside?

A swimming pool viewed from below can behave like a mirror at sufficiently oblique angles. Optical fibers use a related phenomenon to guide light. A simple inequality classifies a ray, but the interesting physics is why the inequality appears and what happens to the electromagnetic field on the other side.

> **Physics — our interface model.** Two homogeneous, isotropic, transparent, nonmagnetic media meet at a plane. Their positive real refractive indices are $n_1$ and $n_2$, with phase speeds $c/n_1$ and $c/n_2$. Light is monochromatic, the interface is flat on wavelength scales, and both media are initially treated as infinite half-spaces. Incidence angle $\theta_i$ and transmission angle $\theta_t$ are measured from the normal, between $0$ and $90^\circ$. Medium 1 is incident-side $z<0$; medium 2 is $z>0$. Absorption, roughness, and finite nearby boundaries need a richer model. At normal incidence the ray remains normal.

## 2.2 Deriving Snell's law from matching phase

A plane wave has phase $\mathbf{k}\cdot\mathbf{r}-\omega t$, where $\mathbf{k}$ points in the propagation direction and has magnitude $k=n\omega/c$. This vector counts how rapidly phase changes per unit distance. A crest travels while its phase stays constant.

The electric and magnetic boundary conditions must hold at every position along the interface and every time. Incident, reflected, and transmitted waves must therefore have the same frequency and the same wave-vector component parallel to the surface. Otherwise their relative phases would change along the boundary and a matching condition at one point would fail elsewhere. Consequently,

$$k_1\sin\theta_i=k_2\sin\theta_t,
\qquad \boxed{n_1\sin\theta_i=n_2\sin\theta_t.}$$

The reflected wave stays in medium 1 and reverses its normal wave-vector component, giving equality of reflection and incidence angles. Snell's law specifies direction, not the fractions of optical power reflected and transmitted; those require the amplitude boundary conditions (Fresnel coefficients).

> **Mathematics — when a real angle exists.** For $0\leq\theta_i<90^\circ$, define $q=(n_1/n_2)\sin\theta_i$. A propagating transmitted ray requires $q\leq1$. If $n_1>n_2$, the boundary is $\theta_c=\arcsin(n_2/n_1)$. For $\theta_i>\theta_c$ there is total internal reflection (TIR); at equality the transmitted direction is grazing. If $n_1\leq n_2$, no incidence angle below $90^\circ$ gives TIR in this ideal model.

## 2.3 Turning the law into a Julia decision

The setup selects the installed graphics backend and formatted numerical output. A placeholder such as `%.3f` prints three decimal places. `println` writes a message deliberately; a notebook otherwise displays the final value automatically.

<!-- code: setup -->

For glass with $n_1=1.50$ and air with $n_2=1.00$, predict whether $50^\circ$ produces a real transmitted angle. `sind` accepts degrees and `asind` returns degrees. We calculate $q$ before calling the inverse sine, so an impossible angle never reaches that operation.

<!-- code: classification -->

The critical angle is about $41.81^\circ$, below the chosen incidence. An inverse-sine domain error here would signal that we attempted the wrong physical branch; it should not be “fixed” by forcing every $q>1$ to one.

> **Check — a numerical boundary has a physical uncertainty.** The explicit `q == 1.0` branch names the ideal mathematical boundary. A value constructed through trigonometric arithmetic may fall slightly to either side because of rounding. For measurements close to critical incidence, propagate the angle and index uncertainty and report “near critical” when the range straddles one. Rounding all angles first or adding a broad numerical tolerance would move a real physical threshold.

Now lower the incidence to $30^\circ$. We expect a transmitted angle larger than incidence because the second medium has smaller index. The picture below shows **paths**, not power fractions; the incident path is traversed toward the origin, while the other paths are traversed away from it.

> **Julia — drawing sampled paths.** `range` supplies evenly spaced values of a distance parameter. `.*` scales each entry; arrays in square brackets give explicit endpoint coordinates. `plot` creates a figure and `plot!` adds lines. `aspect_ratio = :equal` gives the same visual length to equal horizontal and vertical distances. Colours and labels distinguish the three ray paths.

<!-- code: refraction -->

The ray bends away from the normal as expected. Some reflection generally occurs even below the critical angle. Our ray drawing does not calculate that reflected fraction and therefore cannot establish transmission efficiency.

## 2.4 Beyond the ray picture: an evanescent field

“No transmitted ray” does not mean “no field in medium 2.” The parallel wave number is fixed by the incident wave, while the magnitude of the wave vector in medium 2 must satisfy

$$k_{2z}^2+k_\parallel^2=\left(\frac{n_2\omega}{c}\right)^2.$$

Substitution gives

$$k_{2z}^2=\left(\frac\omega c\right)^2
\left(n_2^2-n_1^2\sin^2\theta_i\right).$$

Above the critical angle the right side is negative. Write $k_{2z}=i\kappa$, with $i^2=-1$ and

$$\kappa=\frac{2\pi}{\lambda_0}\sqrt{n_1^2\sin^2\theta_i-n_2^2},
\qquad \lambda_0=\frac{2\pi c}{\omega}.$$

Complex notation is a bookkeeping tool: the physical electric field is the real part. With the time convention $e^{-i\omega t}$, a representative transmitted component has the form

$$E(x,z,t)=\operatorname{Re}\left[E_0e^{ik_\parallel x-i\omega t}e^{-\kappa z}\right].$$

We choose the decaying solution; a field growing without bound as $z\to\infty$ is incompatible with this illumination problem. The amplitude falls by $e^{-1}$ at penetration depth $d=1/\kappa$. Its squared magnitude falls by $e^{-1}$ at $d/2$.

> **Physics — decay is not absorption.** An evanescent wave in a lossless second half-space has no net time-averaged energy flux normal to the interface, even though its field is nonzero. Squared amplitude is not a transmitted normal power in this situation. Energy conservation gives total reflection for the ideal interface. A second high-index medium placed within the decay distance can allow frustrated TIR, transferring power across the gap; then the infinite-half-space assumption fails.

We use vacuum wavelength $\lambda_0=0.55\ \mu$m. Expressing wavelength and distance in micrometres makes $\kappa$ come out in inverse micrometres. `sqrt.` and `exp.` act entry by entry. The log-scaled depth axis reveals the rapid change near critical incidence. We start slightly above the threshold because exactly at it the exponential decay constant is zero.

<!-- code: evanescent -->

At $50^\circ$ the amplitude depth is a small fraction of a micrometre. Approaching critical incidence from above sends $\kappa\to0$ and $d\to\infty$ in this ideal plane-wave calculation. A finite beam or finite geometry need not realize an arbitrarily large penetration depth. Increasing the angle increases $\kappa$ and tightens confinement.

## 2.5 From a flat boundary to an ideal fiber

Consider a straight core of index $n_{\rm core}$ surrounded by lower-index cladding $n_{\rm clad}$. A ray in a plane through the axis is called **meridional**. Let $\alpha$ be its angle to the axis. Its incidence at a straight side wall is $90^\circ-|\alpha|$. TIR requires

$$|\alpha|<\alpha_{\max}=\arccos(n_{\rm clad}/n_{\rm core}).$$

At the flat entrance face, its normal is the fiber axis. For an external medium of index $n_0$, Snell gives $n_0\sin\theta_0=n_{\rm core}\sin\alpha$. At the limiting internal angle,

$$n_0\sin\theta_{0,\max}=\sqrt{n_{\rm core}^2-n_{\rm clad}^2}
\equiv\mathrm{NA}.$$

The dimensionless quantity NA is the **numerical aperture**. If $\mathrm{NA}/n_0>1$, the ray model's angular bound saturates at $90^\circ$; the inverse sine must not be asked to exceed its domain. Unlike clamping an impossible transmitted ray, this `min` represents the explicit limit of available external directions.

<!-- code: acceptance -->

The accepted cone is narrow for weak index contrast. A $5^\circ$ internal axial angle is guided for these indices. Be careful: this angle is not the incidence angle at the wall, nor the external launch angle.

## 2.6 Tracing many reflections without hidden mechanics

Let the transverse core width be $w=0.1$ mm and launch from $y=0$ at $x=0$. Between wall hits $dy/dx=\tan\alpha$. The first hit occurs at $x=w/(2\tan\alpha)$ for positive $\alpha$; later hits are separated by $w/\tan\alpha$. Reflection reverses the transverse direction and preserves the axial direction.

An unfolded line $u=x\tan\alpha$ passes through mirrored copies of the core. Folding it back produces a triangle wave:

$$y(x)=\frac w2-\left|\left[(u+w/2)\bmod(2w)\right]-w\right|.$$

Here $a\bmod b$ means the remainder in $[0,b)$ for $b>0$. On the initial interval $0\leq u\leq w/2$, substitution gives $y=u$; the next interval reverses the slope. Julia's `mod.` applies this remainder to every coordinate and `abs.` supplies the fold. Thus no loop or hidden reflection routine is needed.

<!-- code: fiber -->

The transverse scale is deliberately magnified relative to the axial scale to show the reflections; measure angles from the formulas, not from this stretched picture. A finer $x$ grid resolves the corners more sharply. All points lie within the walls, but a folded curve would do so even for an unguided launch. The preceding TIR test is essential: geometry alone does not prove guiding.

> **Physics — limits of the fiber model.** This is a meridional ray in a straight, ideal step-index guide. We omit entrance reflection losses, absorption, roughness, bends, skew rays, dispersion, and waveguide mode structure. The width is much larger than the optical wavelength. A thin or single-mode fiber requires electromagnetic boundary conditions and interference, rather than this ray construction alone. At $\alpha=0$ the ray follows the axis and never hits a wall; the wall-spacing formula then tends to infinity.

## 2.7 Independent checks

The supplied tests use `@test` to report whether an identity or inequality holds and `isapprox(...; atol=...)` for small floating-point errors. We check normal incidence, the critical equality, Snell's law below critical, the definition of penetration depth, containment, launch position, the guiding condition, and the entrance acceptance relation.

<!-- code: checks -->

## 2.8 Guided investigation and self-test

1. Make a table for incidence $0^\circ,30^\circ,40^\circ,50^\circ$ from glass into air. Predict the category first, calculate transmission only where it exists, and verify Snell's relation there.
2. Reverse the two media. Explain analytically why there is no TIR from air into glass. Do not evaluate an inverse sine outside its real domain when trying to calculate a critical angle.
3. Double the vacuum wavelength at fixed $50^\circ$ incidence. Predict and calculate how amplitude penetration depth changes. Distinguish amplitude from squared amplitude.
4. For the supplied fiber, compare axial launch angles $0^\circ,5^\circ,12^\circ$. Calculate guiding status before drawing a path; identify which folded picture would have no physical justification as a perfectly confined ray.
5. Derive the dependence of NA on a small positive index contrast $\Delta n=n_{\rm core}-n_{\rm clad}$ by factoring the difference of squares. What happens when the contrast vanishes?
6. **Open extension:** explain which assumption fails in a bent fiber and why a straight-guide acceptance test alone cannot predict its losses.

**Deliverable for yourself:** a classification table, a ray diagram, a penetration-depth comparison, and a fiber figure accompanied by its launch-angle calculation. Suggested answers appear in the solutions companion.

**Summary.** Boundary phase matching gives Snell's law; the absence of a real normal wave number gives evanescence; the critical angle leads to ray guiding and numerical aperture. A useful program follows the physical branches before evaluating their formulas.

**Further reading:** [OpenStax University Physics, total internal reflection](https://openstax.org/books/university-physics-volume-3/pages/1-4-total-internal-reflection). For the wave extension, consult an optics text's Fresnel-reflection and evanescent-wave sections; the derivation needed here is provided above.
