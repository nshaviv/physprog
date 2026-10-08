# Get the course files and run Julia

These are the student materials for the course. The student repository is
**nshaviv/physprog**.

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

Keep personal answers in a separate working directory. Obtain updates with:

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
