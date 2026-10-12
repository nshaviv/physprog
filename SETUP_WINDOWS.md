# Windows setup — from nothing to submitting Exercise 1

This page assumes you have **never opened a terminal (command window)** before.
Follow it in order, doing one step at a time. Each command is shown in a grey box;
copy it, paste it into the black command window, and press **Enter**.

You will end with the first homework submitted on Moodle. Budget about 45–60
minutes the first time.

If you only want to **read** the course (book, slides, homework sheets), you need
no software at all — skip to [Reading the course](#14-reading-the-course-no-software).
This page is for running code and submitting Exercise 1.

---

## Contents
1. [Look at the checklist](#1-the-checklist)
2. [Open the command window (PowerShell)](#2-open-the-command-window-powershell)
3. [Install Git](#3-install-git)
4. [Install Julia](#4-install-julia)
5. [Install Visual Studio Code](#5-install-visual-studio-code)
6. [Get the course files](#6-get-the-course-files)
7. [Install the course Julia packages](#7-install-the-course-julia-packages)
8. [Open the course folder in VS Code](#8-open-the-course-folder-in-vs-code)
9. [Install the Julia extension in VS Code](#9-install-the-julia-extension-in-vs-code)
10. [Find the data file `free_fall.csv`](#10-find-the-data-file-free_fallcsv)
11. [Write the program `freefall.jl`](#11-write-the-program-freefalljl)
12. [Run the program](#12-run-the-program)
13. [Find the figure you made](#13-find-the-figure-you-made)
14. [Reading the course (no software)](#14-reading-the-course-no-software)
15. [Submit Exercise 1 on Moodle](#15-submit-exercise-1-on-moodle)
16. [If something goes wrong](#16-if-something-goes-wrong)
17. [Quick reference — every command](#17-quick-reference--every-command)

---

## 1. The checklist

By the end you will have installed, in this order:

- **Git** — the tool that copies the course files to your computer.
- **Julia** — the programming language this course uses.
- **Visual Studio Code (VS Code)** — the editor where you write programs.
- The **course files** (a folder named `physprog`).
- The **Julia extension** for VS Code.

Then you write one short program, run it, and upload the program and its figure to
Moodle. Everything downloads from the internet, so stay online.

> Tip: if a command seems to "do nothing", wait a few seconds — downloading and
> installing take time. Never close the window while text is still scrolling.

---

## 2. Open the command window (PowerShell)

On Windows, "the terminal" is called **PowerShell**.

1. Click the **Start** button (the Windows logo, bottom-left).
2. Type the word `powershell`.
3. Click **Windows PowerShell** in the list that appears.

A dark-blue or black window opens with a line that ends in a `>` sign. This window
is where you will paste commands. To paste: copy the command here, then
**right-click** inside the window (right-click pastes in PowerShell), or press
**Ctrl+V**.

> If you prefer, you can also open it with the keyboard: hold **Windows** and press
> **X**, then choose **Terminal** or **Windows PowerShell**. The result is the same.

From now on, "paste the command and press Enter" means: copy the grey box, click
inside PowerShell, paste, press Enter.

---

## 3. Install Git

Paste this command and press Enter:

```
winget install --id Git.Git -e --source winget
```

If Windows asks for permission, click **Yes**. When it finishes, **close the
PowerShell window and open a new one** (Start → type `powershell` → open). This
makes Windows notice the new program.

Check it worked:

```
git --version
```

You should see something like `git version 2.x.x`.

> If `winget` is not recognised, open the **Microsoft Store**, search for
> **App Installer**, and update/install it, then repeat this step. You can also
> download Git by hand from <https://git-scm.com/downloads> (choose Windows, run
> the installer, click Next through the defaults).

---

## 4. Install Julia

The course uses **Julia 1.12**, installed through its version manager **Juliaup**.
Paste this command and press Enter:

```
winget install julia -s msstore
```

Click **Yes** / **Get** if asked, and let it finish. Then **close PowerShell and
open a new one**.

In the new window, add the course's Julia version and check it:

```
juliaup add 1.12
julia +1.12 --version
```

The second command should print a line beginning with `julia version 1.12`.

> The `+1.12` part means "run the 1.12 version of Julia". Use it every time.
> You can also install Julia by hand from <https://julialang.org/install/>.

---

## 5. Install Visual Studio Code

Paste this command and press Enter:

```
winget install --id Microsoft.VisualStudioCode -e
```

Let it finish, then close PowerShell and open a new one. (Or download VS Code from
<https://code.visualstudio.com/> and run the installer with the default options.)

---

## 6. Get the course files

You will create a folder called `physprog` that holds all the course material.
Choose where to put it — `Documents` is a good place. There are two ways; pick one.

### Way A — with Git (recommended)

Paste these two commands, one at a time:

```
cd "$HOME\Documents"
git clone https://github.com/nshaviv/physprog.git
```

The first line moves to your Documents folder. The second downloads the course and
creates a `physprog` folder. When it finishes, go into it:

```
cd physprog
```

### Way B — without Git (Download ZIP)

1. Open your browser (Edge or Chrome) and go to
   <https://github.com/nshaviv/physprog>.
2. Click the green **Code** button, then **Download ZIP**.
3. The file `physprog-main.zip` lands in your **Downloads**.
4. Open **File Explorer**, go to Downloads, right-click `physprog-main.zip`, and
   choose **Extract All…**. Extract to `Documents`. You now have
   `Documents\physprog-main`.
5. Back in PowerShell, type:

```
cd "$HOME\Documents\physprog-main"
```

Either way, check you are in the right place — this prints a list of files:

```
dir
```

You should see names like `assets`, `classnotes`, `week-1`, `Project.toml`.

> Keep using the same folder name from here on. If you used the ZIP, your folder is
> `physprog-main`; if you used Git, it is `physprog`. In the examples below we write
> `physprog`; use whichever you have.

---

## 7. Install the course Julia packages

Make sure you are inside the course folder (the `dir` command above listed
`Project.toml`). Then paste:

```
julia +1.12 --project=. -e "using Pkg; Pkg.instantiate()"
```

This downloads the packages the course uses (CSV, DataFrames, Plots, and others).
It may take a few minutes the first time. Then check everything works:

```
julia +1.12 --project=. verify_environment.jl
```

The last line it prints should be:

```
Course Julia environment verified.
```

---

## 8. Open the course folder in VS Code

From inside the course folder, paste:

```
code .
```

The dot means "this folder". VS Code opens with the course files listed on the
left.

> If `code` is not recognised, don't worry: open VS Code from the Start menu, then
> choose **File → Open Folder…**, navigate to `Documents\physprog` (or
> `physprog-main`), and click **Select Folder**.

---

## 9. Install the Julia extension in VS Code

1. In VS Code, click the **Extensions** icon in the left bar (four squares), or
   press **Ctrl+Shift+X**.
2. In the search box type `Julia`.
3. Find the extension named **Julia** by *julialang* and click **Install**.
4. Wait until it finishes.

If VS Code ever says it "cannot find Julia", set the path: press **Ctrl+Shift+P**,
type `Preferences: Open Settings (UI)`, search for `julia.executablePath`, and
paste the path to the Julia program (for a standard install it looks like
`C:\Users\<your-name>\.julia\juliaup\julia-1.12.6+0.x64.w64.mingw32\bin\julia.exe`).
If you cannot find it, ask in the course forum — this is a common, easily fixed
step.

---

## 10. Find the data file `free_fall.csv`

The exercise uses a small table of measurements. It is already inside the course
folder at:

```
assets\data\free_fall.csv
```

Open it in VS Code: in the left panel click `assets`, then `data`, then
`free_fall.csv`. It is plain text: the first line names the columns (`t_s` for time
in seconds, `y_m` for distance in metres) and each later line is one measurement.
You do **not** need to edit it.

---

## 11. Write the program `freefall.jl`

1. In VS Code, choose **File → New Text File**.
2. Paste the whole program below into it.
3. Choose **File → Save As…**, navigate to your course folder, name the file
   **`freefall.jl`**, and save.

```julia
using CSV, DataFrames, Plots

# Find the data file (this also works if you later keep your own scripts elsewhere).
root = get(ENV, "PHYSPROG_HOME", pwd())
datafile = joinpath(root, "assets", "data", "free_fall.csv")
# If free_fall.csv is beside this script instead, use: datafile = "free_fall.csv"
table = CSV.read(datafile, DataFrame)

t_s = table.t_s            # s
y_m = table.y_m            # m

t2 = t_s .^ 2              # s^2
t2_bar = sum(t2) / length(t2)
y_bar  = sum(y_m) / length(y_m)
a = sum((t2 .- t2_bar) .* (y_m .- y_bar)) / sum((t2 .- t2_bar) .^ 2)  # m/s^2
b = y_bar - a * t2_bar     # m
g = 2 * a                  # m/s^2
predicted = a .* t2 .+ b   # m

println("g = ", g, " m/s^2")
println("offset = ", b, " m")

p = plot(t_s, y_m; seriestype = :scatter, label = "measured",
         xlabel = "time (s)", ylabel = "distance (m)")
plot!(p, t_s, predicted; label = "fit")
savefig(p, "freefall_fit.pdf")    # or "freefall_fit.png"
```

What it does, line by line: it loads the tools; finds and reads the CSV table;
takes the two columns; squares the times; computes the best straight line through
the points (the "fit"); reports the inferred gravity `g` and the small offset; and
draws a figure with the measured points and the fitted line, saving it as
`freefall_fit.pdf`.

---

## 12. Run the program

1. Make sure the file `freefall.jl` is open and saved.
2. If VS Code asks you to select the environment, choose the one for this folder
   (it contains the course packages). If not asked, it is already using it.
3. Press **Ctrl+F5** (menu: **Run → Run Without Debugging**).

A panel opens at the bottom and prints something like:

```
g = 9.8240786241 m/s^2
offset = 0.01172972973 m
```

That is your fit. (The exact digits may differ slightly.)

> To instead run one line at a time and watch each result, put the cursor on a line
> and press **Shift+Enter**; the result appears in the panel. This is a great way to
> understand what each line does.

---

## 13. Find the figure you made

The program saved `freefall_fit.pdf` **in the folder it ran from** — your course
folder. Use File Explorer to open `Documents\physprog\freefall_fit.pdf` (or
`physprog-main`). It shows your measured points and the fitted line.

That PDF (or a PNG, if you saved one) is one of the two things you submit.

---

## 14. Reading the course (no software)

You can read everything with just a browser, no installs:

- Course website: <https://nshaviv.github.io/physprog/>
- Lecture book (PDF), slides, homework sheets and the optional further-reading
  chapters are all linked there.

None of that is required for Exercise 1, but it is where the explanations live.

---

## 15. Submit Exercise 1 on Moodle

You need two files ready:
- `freefall.jl` (your program), and
- `freefall_fit.pdf` (your figure).

Steps:

1. Open your browser and go to <https://moodle.huji.ac.il>.
2. Log in with your Hebrew University account.
3. Open the course **76641 – Programming in Julia and Python and Computational
   Methods for Physicists**.
4. Click the week **"שבוע 1 – מבוא לג'וליה"** (Week 1).
5. Click the assignment **"תיבת הגשה – תרגיל 1"** (the Exercise 1 submission box).
6. Click the **Add submission** / **Add…** button.
7. Drag both files (`freefall.jl` and `freefall_fit.pdf`) into the upload area, or
   click to choose them from your course folder.
8. Click **Save changes** (and, if present, **Submit assignment**), then confirm.

Your submission is checked by hand and marked pass/fail. You can keep improving and
resubmit before the deadline shown on the Moodle page.

> If the box refuses a file, make sure you are uploading your **own** files (not a
> folder) and that the names end in `.jl` and `.pdf`/`.png`.

---

## 16. If something goes wrong

- **`winget` is not recognised.** Open **Microsoft Store → App Installer** and
  update it, then try again.
- **`git`, `julia`, or `code` "is not recognized".** Close PowerShell and open a
  new one — new programs are only seen in a fresh window.
- **`using CSV` fails / "Package CSV not found".** You are using the wrong Julia
  environment. Make sure you are in the course folder and run with
  `--project=.`, as in step 7; in VS Code, select the environment for this folder.
- **`free_fall.csv` not found.** `datafile` is a path, not part of the Julia
  environment. Either run the script from the course folder (as above), or set an
  environment variable so the script can find the course folder:
  ```
  $env:PHYSPROG_HOME = "$HOME\Documents\physprog"
  ```
  or simply copy `free_fall.csv` next to `freefall.jl` and change the line to
  `datafile = "free_fall.csv"`.
- **VS Code cannot find Julia.** Set `julia.executablePath` (step 9).
- **The plot does not pop up.** It is saved to a file, not shown on screen; open
  `freefall_fit.pdf` in the course folder (step 13).
- **Moodle will not accept the files.** Check they are single files with the right
  extensions, and that your browser is logged in to your HUJI account.

If you are stuck, write down the exact red message and your Windows version, and
ask in the course forum.

---

## 17. Quick reference — every command

Run these in PowerShell, in the course folder unless noted.

```
# Install the tools (once)
winget install --id Git.Git -e --source winget
winget install julia -s msstore
winget install --id Microsoft.VisualStudioCode -e
# close and reopen PowerShell after installing

# Add the course Julia version (once)
juliaup add 1.12

# Get the course files (once; or use Download ZIP)
cd "$HOME\Documents"
git clone https://github.com/nshaviv/physprog.git
cd physprog

# Install the course packages (once) and verify
julia +1.12 --project=. -e "using Pkg; Pkg.instantiate()"
julia +1.12 --project=. verify_environment.jl

# Open the folder in VS Code
code .
```

That is the whole setup. Welcome to the course!
