# Get the course files and run Julia

These are the student materials for the course. The student repository is
**nshaviv/physprog**. Reading the book needs no software; installing Julia is
optional, for running the examples yourself. Homework is submitted on the course
**Moodle** page.

**Completely new to this?** Follow the click-by-click guide for your computer, which
starts from a brand-new machine and ends with the first exercise submitted:
[Windows](SETUP_WINDOWS.md) · [macOS](SETUP_MACOS.md). The rest of this page is the
reference version for both systems.

## 1. Install the tools

Install Git from https://git-scm.com/downloads and Julia through Juliaup from
https://julialang.org/install/. On Windows, the official Juliaup installation can
be started in PowerShell with:

```powershell
winget install julia -s msstore
```

On macOS and Linux, the official Juliaup installer is:

```bash
curl -fsSL https://install.julialang.org | sh
```

Restart the terminal after installation. Install the course's Julia 1.12 channel:

```bash
juliaup add 1.12
julia +1.12 --version
```

The output begins with `julia version 1.12`; the patch version may change. Course
examples have been checked with Julia 1.12.6.

Install Visual Studio Code from https://code.visualstudio.com/ and its official
Julia extension. Lab computers may already have these tools.

If VS Code cannot find Julia, or you meet another installation problem, see the
separate [INSTALL.md](INSTALL.md) page (with screenshots of the executable-path
setting).

## 2. Clone into a location we choose

In Terminal, PowerShell, or VS Code's terminal, navigate to the parent directory
where we want to keep the course, then run:

```bash
git clone https://github.com/nshaviv/physprog.git
cd physprog
```

Git creates the local folder. Open this repository folder in VS Code.

## 3. Install the recorded Julia environment

Run from the repository root, which contains `Project.toml`:

```bash
julia +1.12 --project=. -e 'using Pkg; Pkg.instantiate()'
julia +1.12 --project=. verify_environment.jl
```

The first command downloads the recorded dependencies and may precompile them.
The verification script ends with:

```text
Course Julia environment verified.
```

Select the same project environment in VS Code's Julia extension.

### What gets installed

| Package | Course responsibility |
|---|---|
| `BenchmarkTools` | Careful timing and benchmarking |
| `CSV` | Reading and writing delimited data |
| `DataFrames` | Tabular data preparation and summaries |
| `IJulia` | Julia kernel for the lecture and recitation notebooks |
| `Optim` | Bounded and nonlinear optimization |
| `OrdinaryDiffEq` | Numerical ordinary differential equations |
| `Plots` | Common plotting interface and GR output |
| `PlotlyJS` | Interactive plotting backend |
| `StableRNGs` | Reproducible teaching and test random streams |
| `Unitful` | Physical quantities with units |

`LinearAlgebra`, `Random`, `Statistics`, and `Test` are Julia standard libraries;
Julia 1.12 supplies them, so they are not installed with `Pkg.add`. The recorded
versions are pinned in `Manifest.toml`, so the same commands reproduce the same
environment on another machine.

## Working from your own folder (optional)

It is fine to keep your own scripts outside the cloned course folder. Two things
must still find each other: the **packages** (the recorded environment) and the
**data files**.

The recorded packages live in the cloned course folder (the one containing
`Project.toml`). Point Julia at it explicitly, from any folder:

```bash
julia +1.12 --project=/path/to/physprog your_script.jl
```

or set it once for the shell:

```bash
export JULIA_PROJECT=/path/to/physprog      # macOS/Linux
# $env:JULIA_PROJECT="C:/path/to/physprog"  # PowerShell
```

In VS Code, open your own folder and set the Julia extension to the course
environment — for example the setting
`"julia.environmentPath": "/path/to/physprog"`, or the command palette command
**Julia: Select Environment**. Then `using CSV` and `using Plots` load the course
versions while your files stay where you like.

Data files are read by a path, so they do not follow the environment. Choose one:

*Point the script at the course folder.* Set `PHYSPROG_HOME` to the folder you
cloned, next to `JULIA_PROJECT`, and read the data through it:

```julia
root = get(ENV, "PHYSPROG_HOME", pwd())     # the cloned course folder
datafile = joinpath(root, "assets", "data", "free_fall.csv")
table = CSV.read(datafile, DataFrame)
```

*Or copy the file beside your script.* The data files are tiny. Copy
`assets/data/free_fall.csv` (or download it from the course web page) next to your
script and read it directly:

```julia
table = CSV.read("free_fall.csv", DataFrame)
```

Either way, `using CSV, DataFrames` still needs the course environment above.

## 4. Notebooks (optional) and personal work

The lecture and recitation notebooks live in each week folder, for example
`week-1/notebooks/lecture_01-en.ipynb`. They are optional interactive companions;
each one already contains its saved outputs, so we can read them without running
anything. Running or editing a notebook is optional and needs a Jupyter kernel,
which we can open either in **JupyterLab** or in **VS Code** with Microsoft's
**Jupyter** extension.

Register the kernel once from the repository root:

```bash
julia +1.12 --project=. -e 'using IJulia; IJulia.installkernel("Julia 1.12", "--project=@."; specname="julia-1.12", displayname="Julia 1.12")'
```

In VS Code, open the repository root, open a notebook, click **Select Kernel**, and
choose **Julia 1.12** (or the course Python kernel for the Chapter 0 Python
companions). Use **Restart Kernel and Run All** to reproduce a chapter.

Keep personal answers in a separate working directory (see *Working from your own
folder* above for how to use the course environment and data from there). Obtain
updates with:

```bash
git status
git pull --ff-only
```

If Git reports conflicting local work, retain it and ask for help rather than
resetting. Repeat `Pkg.instantiate()` if a release updates the environment.

## If setup fails

Record the operating system, `julia +1.12 --version`, VS Code version, working
directory, and exact error message. A missing package often means the wrong
environment is selected.

## הוראות קצרות בעברית

לאחר פרסום המאגר נבחר תיקיית אב במחשב האישי ונריץ את פקודת השכפול שלעיל.
Git ייצור בתוכה את תיקיית הקורס. נפתח אותה ב-VS Code ונריץ משורש המאגר את
פקודות התקנת הסביבה והבדיקה (עם `--project=.`). נבחר אותה סביבה גם בהרחבת
Julia. המחברות נמצאות בתיקיות השבוע, למשל `week-1/notebooks/`. נשמור עבודה
אישית בנפרד, ונשתמש ב-`git status` לפני קבלת עדכון באמצעות `git pull --ff-only`.

אפשר לשמור סקריפטים בתיקייה נפרדת. כדי להשתמש בסביבת הקורס מכל תיקייה, מריצים
`julia +1.12 --project=/path/to/physprog script.jl`, או מגדירים `JULIA_PROJECT`
פעם אחת; ב-VS Code מגדירים `julia.environmentPath` לתיקיית הקורס. קבצי הנתונים
נקראים לפי נתיב, ולכן מגדירים גם `PHYSPROG_HOME` לתיקיית הקורס וקוראים דרך
`joinpath(root, "assets", "data", "free_fall.csv")`, או מעתיקים את קובץ ה-CSV
לצד הסקריפט וקוראים `CSV.read("free_fall.csv", DataFrame)`.
