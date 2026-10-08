# 1. Lissajous curves: seeing frequency and phase

**Optional self-study · approximately 90–120 minutes, including experiments.** This exploration is unexamined, carries no extra-credit requirement, and is not a prerequisite for later work. It is separate from the Week 1 bonus. We assume scalar arithmetic and assignment; we teach the extra plotting and vector notation here as supplied tools. No function definitions are needed.

## 1.1 The physical question

Imagine a small mass attached to restoring springs in two perpendicular directions. We watch its position from above. Each coordinate may oscillate sinusoidally, yet the combined path can be an ellipse, a line, or an intricate repeating pattern. How can a two-dimensional picture tell us about two clocks?

The same mathematics describes the horizontal and vertical deflections of an oscilloscope in XY mode. In that application the coordinates represent voltages rather than lengths. A graph of one signal against another has a shared time parameter even though time is not an axis. We will learn to distinguish that **parametric curve** from two separate position-versus-time graphs.

> **Physics — two independent restoring forces.** We choose rightward $x$ and upward $y$ positive. For a mass $m$ in kg, $F_x=-k_xx$ and $F_y=-k_yy$, where $k_x,k_y>0$ are spring constants in N/m. Small displacements, linear springs, negligible damping, and no coupling between directions give $m\ddot{x}=-k_xx$ and $m\ddot{y}=-k_yy$. The minus sign makes each force restoring. The origin is the equilibrium; the path is generally not a gravitational orbit. At zero displacement the restoring force in that direction vanishes. Large displacements, friction, driving, or coupling require a different model.

For one coordinate, a cosine has second derivative equal to minus itself times the square of its angular frequency. Substitution therefore gives $\omega_x=\sqrt{k_x/m}$. We choose the time origin so the $y$ oscillation has zero sine phase:

$$x(t)=A\cos(\omega_x t+\delta),\qquad y(t)=B\sin(\omega_y t).$$

Here $A,B$ are positive amplitudes in m, $t$ is in s, $\omega_x,\omega_y$ are positive angular frequencies in rad/s, and $\delta$ is in radians. One full turn is $2\pi$ radians. Ordinary frequency is $f=\omega/(2\pi)$ in Hz, and period is $T=1/f$. We start with $A=0.02$ m and $B=0.01$ m: stretching one axis should stretch the picture without changing its timing.

> **Mathematics — phase is a position within a cycle.** Adding $2\pi$ to a phase changes no observable value. With our cosine/sine convention, $\delta=0$ does **not** mean the coordinates are in phase: cosine already leads sine by a quarter cycle. Always write the actual sine/cosine definitions before interpreting the sign of a phase.

## 1.2 One instant, then an entire motion

We load the already installed plotting package. `using` makes its tools available; `gr()` selects its graphics backend. `default` supplies presentation settings. `Printf` provides formatted output: `%.2f` prints two decimal places, while the stored value keeps full precision. These setup choices change appearance, not physics.

<!-- code: setup -->

Before running the next example, evaluate it mentally: after a quarter second at 1 Hz, cosine is zero and sine is one. We expect $x=0$ and $y=B$.

<!-- code: scalar -->

A displayed zero here is rounded; the computed cosine may be about $6\times10^{-17}$ rather than exactly zero. That is floating-point evaluation of a mathematical identity, not a detectable physical displacement.

> **Julia — a small plotting vocabulary.** `range(0.0, 1.0; length = 501)` supplies 501 equally spaced times, including both endpoints. `length` counts them and `step` reports the spacing. A vector holds one value for each time. The dots in `cos.(...)`, `.*`, and `.+` mean “apply this operation separately to every entry.” For example, squaring the entries 2 and 3 produces 4 and 9; it is not a matrix product. `plot(times, xs)` pairs the first time with the first position, and so on. `plot!` adds a series to an existing figure. `display` shows a figure explicitly, including when the example is run as a script.

<!-- code: sampling -->

The first figure keeps the two clocks visible. The second eliminates time from the axes and follows the coordinate pair. Its equal aspect ratio is important: one metre has the same visual length on both axes. With $A\ne B$ we expect an ellipse, not a circle. Connected points are samples of the analytic model, not new measurements or the output of an ODE solver.

## 1.3 Deriving the equal-frequency ellipse

For equal angular frequencies write $u=\omega t$, $X=x/A$, and $Y=y/B$. The addition formula gives

$$X=\cos u\cos\delta-\sin u\sin\delta,
\qquad X+Y\sin\delta=\cos u\cos\delta.$$

Squaring and using $\cos^2u=1-Y^2$ gives

$$\boxed{X^2+Y^2+2XY\sin\delta=\cos^2\delta.}$$

At $\delta=0$ this is the familiar ellipse $X^2+Y^2=1$. At $\delta=\pi/2$ it becomes $(X+Y)^2=0$, so the curve collapses to the line $X=-Y$. At $\delta=-\pi/2$ the line instead has positive slope. For intermediate phases the ellipse is tilted. These are geometric consequences of phase, not evidence that energy has been lost.

Predict the two shapes in the next figure. The residual is the left-hand side minus the right-hand side of the boxed equation, evaluated at every sampled point. `abs.` takes absolute values and `maximum` finds the largest. Powers with dots are entrywise powers. A tiny residual checks the derivation and the code together.

<!-- code: phase -->

The line at a quarter-cycle phase and the tilted ellipse agree with the derivation. The residual's last digits can vary with numerical libraries; its scale should remain near machine precision. The collapsed line is traversed back and forth: a path's shape alone does not reveal its direction or speed.

## 1.4 Why some patterns close

For the **full state** to repeat, both positions and velocities must repeat. A sufficient and, for nonzero amplitudes and positive frequencies, necessary condition is that both oscillator phases advance by integer numbers of cycles:

$$\omega_x T=2\pi p,\qquad \omega_y T=2\pi q,$$

for positive integers $p,q$. Dividing shows that $\omega_x/\omega_y=p/q$ must be rational. If $p$ and $q$ share no factor and $\omega_x=p\Omega$, $\omega_y=q\Omega$, the fundamental state period is $2\pi/\Omega$.

For $f_x=3$ Hz and $f_y=2$ Hz, the state repeats after one second. The velocities follow by differentiation:

$$v_x=-A\omega_x\sin(\omega_xt+\delta),\qquad
v_y=B\omega_y\cos(\omega_yt).$$

We compare both ends of the sampled interval. `xs[1]` is the first entry and `xs[end]` is the last; `hypot(dx,dy)` computes $\sqrt{dx^2+dy^2}$. Endpoint position agreement alone could also describe an accidental crossing.

<!-- code: closure -->

The small position **and** velocity mismatches support the predicted period. A crossing inside the curve usually occurs with different velocities on the two passages. It is not a return of the complete physical state.

> **Check — closure is not resonance.** We have specified free oscillations, with no periodic driving force. Rational frequency ratios make a picture repeat; they do not by themselves imply resonant energy absorption. A driven oscillator requires an equation with an external force and, usually, damping.

## 1.5 Nearly equal clocks and apparent nonclosure

Suppose the frequencies are 1.01 Hz and 1 Hz. Their relative phase changes at $\Delta\omega=0.01(2\pi)$ rad/s, completing a cycle in

$$T_{\rm relative}=\frac{2\pi}{|\Delta\omega|}=100\ {\rm s}.$$

Over one second the figure looks almost like an ellipse. Over 100 seconds it draws many strands. Yet 1.01 is the rational number 101/100 in the mathematical model, so this example eventually closes. We use two plots side by side: `layout = (1, 2)` means one row and two columns.

<!-- code: detuning -->

An exactly irrational frequency ratio has no finite full-state period. Ideal motion with such a ratio densely visits the allowed rectangle over arbitrarily long times, although any finite plotted segment is only a curve. Neither a crowded figure nor finite-precision decimal frequencies can prove irrationality. Frequency measurements also have uncertainty. We can report recurrence within a stated tolerance and observation window, not establish an infinite-time theorem by a finite experiment.

## 1.6 Can plotting invent a shape?

The computer draws straight segments between sampled points. Four intervals around an ellipse produce a diamond-like polygon. The motion equation did not change; only our representation did.

<!-- code: aliasing -->

> **Check — sampling and aliasing.** A sinusoid sampled regularly needs a sampling frequency greater than twice its frequency to avoid the simplest aliasing ambiguity; that threshold alone does not guarantee a smooth or informative plot. Start with at least 50–100 samples per fastest cycle, then halve the time spacing. If the apparent geometry changes substantially, it was not yet resolved. Sampling exactly once per cycle can even make motion appear stationary.

## 1.7 Energy as an independent physical check

The potential energy is $U=\tfrac12 k_xx^2+\tfrac12 k_yy^2$. Including kinetic energy gives

$$E=\frac m2(v_x^2+v_y^2)+\frac m2(\omega_x^2x^2+\omega_y^2y^2)
=\frac m2(\omega_x^2A^2+\omega_y^2B^2).$$

The equality follows separately in each coordinate from $\sin^2+\cos^2=1$. Energy is constant even for a complicated or nonclosed path. The following supplied checks use `@test` for a condition that should be true and `isapprox` for floating-point agreement within an absolute tolerance. `@testset` groups results. They reuse the 3:2 arrays saved above; later frequency choices did not overwrite those arrays.

<!-- code: checks -->

Passing these checks establishes agreement with our ideal model, not the accuracy of that model for a real spring. A measured decay in amplitude would motivate damping; a systematic change in frequency with amplitude would motivate a nonlinear restoring force.

## 1.8 Guided investigation and self-test

1. **Predict, then plot:** hold the frequencies equal and compare $\delta=0,\pi/4,\pi/2,-\pi/2$. Record the shape and the coordinate pair at $t=0$. Explain both line slopes using the equations.
2. **Build a period table:** for ratios 1:1, 2:1, and 3:2, choose $f_y=1$ Hz, calculate the first full-state return time, and test position and velocity at that time. Supply units. Keep at least 100 samples per fastest cycle.
3. **Change one physical quantity:** double $A$ only. Predict the change in width, height, period, and energy in the $x$ oscillator before plotting. Preserve $B$ and both frequencies.
4. **Diagnose a figure:** plot 3:2 motion with sampling intervals of 0.5 s and 0.002 s over two seconds. Explain why endpoint agreement can coexist with a misleading polygon.
5. **Open extension:** compare $\omega_x/\omega_y=\sqrt{2}$ with 1.414 over 10 s and 100 s. Write a conclusion that separates the exact mathematical model from numerical evidence.

**Deliverable for yourself:** two contrasted figures, a frequency/period table, a dimensional or energy check, and a paragraph explaining which observation was a physical effect and which was a sampling effect. Suggested answers are in the separate solutions companion; consult them after making predictions.

**Summary.** We learned parametric motion, angular frequency, phase, the equal-frequency ellipse, rational closure, detuning, and sampling ambiguity. A credible picture has a governing model, labelled axes, a time window, and checks beyond visual appearance.

**Further reading:** [OpenStax University Physics, simple harmonic motion](https://openstax.org/books/university-physics-volume-1/pages/15-1-simple-harmonic-motion); [Julia mathematical operations](https://docs.julialang.org/en/v1/manual/mathematical-operations/). The explanations above are sufficient for the investigation; these references extend it.
