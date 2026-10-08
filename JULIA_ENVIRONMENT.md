# Course Julia Environment

The shared `course_material/Project.toml` and `course_material/Manifest.toml` define the Julia 1.12 package environment used by the Semester A notes, notebooks, and instructor demonstrations.

## Install

From the repository root, install and precompile the recorded package versions with one command:

```sh
julia --project=course_material -e 'using Pkg; Pkg.instantiate()'
```

This command may download packages, so run it before class with network access. Do not run `Pkg.add` in course notebooks or graded work. When using VS Code, open the repository root and select `course_material` as the Julia environment.

To start a terminal REPL in the environment, run:

```sh
julia --project=course_material
```

## Package Inventory

| Package | Course responsibility |
|---|---|
| `BenchmarkTools` | Careful timing and benchmarking |
| `CSV` | Reading and writing delimited data |
| `DataFrames` | Tabular data preparation and summaries |
| `IJulia` | Julia kernel for executing the complete lecture and recitation Jupyter notebooks |
| `Optim` | Bounded and nonlinear optimization |
| `OrdinaryDiffEq` | Numerical ordinary differential equations |
| `Plots` | Common plotting interface and GR output |
| `PlotlyJS` | Interactive plotting backend |
| `StableRNGs` | Reproducible teaching and test random streams |
| `Unitful` | Physical quantities with units |

`LinearAlgebra`, `Random`, `Statistics`, and `Test` are Julia standard-library modules. Julia 1.12 supplies them, so they are not packages to install with `Pkg.add`.

## Verify

Run the automated import and plotting smoke test from the repository root:

```sh
julia --project=course_material course_material/scripts/verify_environment.jl
```

The script loads every listed package, renders with both configured plotting backends, and writes temporary PNG, PDF, and HTML files outside the repository. A final `Course Julia environment verified.` message means the check passed.

If verification fails, first confirm that `julia --version` reports Julia 1.12 and that VS Code is using the `course_material` environment. Restart the Julia REPL after changing environments. Also check network access during instantiation and write permission for the system temporary directory.

## Jupyter notebooks

The complete chapter notebooks are indexed in [notebooks/README.md](notebooks/README.md).
After instantiation, register the Julia kernel once from the repository root:

```sh
julia +1.12 --project=course_material -e 'using IJulia; IJulia.installkernel("Julia 1.12", "--project=@."; specname="julia-1.12", displayname="Julia 1.12")'
```

This is a terminal setup command, not a teaching cell. `--project=@.` locates the
course project above each notebook directory. The notebook's supplied first cell
also activates that project explicitly. Install JupyterLab in the separate Python
environment described in the notebook README. The Chapter 0 Python companions
use that Python environment, not the Julia kernel.
