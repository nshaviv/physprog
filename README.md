# Physics Programming — student materials (77641)

Student materials for the first-year course **77641 Physics Programming
(Julia + Python)**: the orientation chapter, lecture notes through Week 8,
and assignments through Week 7. English is the default;
the books and assignments are also available in Hebrew and Arabic, and the slides
in English and Hebrew.

## Start here

You can read everything with no software installed.

- **Read the lecture book:** [`classnotes/notes-en/main.pdf`](classnotes/notes-en/main.pdf)
  (also [עברית](classnotes/notes-he/main.pdf) · [العربية](classnotes/notes-ar/main.pdf)).
- **Homework and bonus:** `week-N/HW{N}-{lang}.pdf`, `week-N/Bonus{N}-{lang}.pdf`,
  `week-N/Bonus{N}-averaging-{lang}.pdf` (the Week 4 optional extra).
  Homework is submitted on the course **Moodle** page. Weeks 2–5 use complete
  core programs in CodeRunner; Week 6 uses function definitions. Follow the
  submission instructions on each assignment sheet.
- **Slides:** `week-N/presentation/` (Weeks 0–3).
- **Recitation book:** `recitations/recitation-{lang}/main.pdf` (through Week 5).
- **Julia reference:** [four-page cheatsheet](reference/julia-cheatsheet.pdf)
  (English), including `do` blocks and the semester packages. It also covers
  planned later-week tools; it does not expand the current exam syllabus.

Release: **Chapters 7–8 and Week 7 assignments**. No worked solutions are
included. The later chapters do not add slides, recitation notes, or
notebooks to this release. File checksums are recorded in
[`RELEASE.json`](RELEASE.json).

There is a one-page web index with the same links at
[nshaviv.github.io/physprog](https://nshaviv.github.io/physprog/).

## Running the code (optional)

The [Week 3 Julia examples](examples/week03-examples.jl) collect the lecture
snippets, including the Euler trajectory plot. The
[Week 4 examples](examples/week04-examples.jl) cover matrices, nested loops,
`while` loops, and rotations; the four keyboard-input examples there are also
split into standalone scripts under `examples/week04_readline_examples/`, which
run cleanly from a terminal. Run each complete `begin … end`
or `let … end` block in the Julia REPL or send it from VS Code with Shift+Enter. These examples
are intended for interactive use; running the file as a standalone script uses
different loop-variable rules.

The [Week 6 Julia examples](examples/week06-examples.jl) cover functions as
arguments, complex numbers, dispatch, tuples, and collection operations. Run
them section by section: several calls deliberately demonstrate errors and
will stop a whole-file run.

HW6 has four separate CodeRunner submissions, A–D. Submit only the function
definitions requested in each part; earlier helpers are supplied in B–D.
Reported distance and angle use four decimal places. See the assignment for
the exact submission contents.

The [Bonus 6 background examples](examples/week06-bonus-background.jl) accompany
the self-contained phasor/interference preamble before the slit exercise.
This physics is optional and unexamined. The required Week 6 chapter ends with
`map`/`filter`/`filter!`; piping begins in Week 7.

The [Week 7 Julia examples](examples/week07-examples.jl) cover piping,
linear systems, and least squares. HW7 includes a
[Julia starter](week-7/hw07-starter.jl) and a
[pipeline template](week-7/hw07-pipeline-template.txt).
For Bonus 7, download the [starter](week-7/bonus07-starter.jl),
[driver](week-7/bonus07-run.jl), and [plot helper](week-7/bonus07-plot.jl)
into the same folder. The Chapter 8 examples use two sample files:
[lamp readings](examples/data/week08-lamp.csv) and
[background readings](examples/data/week08-background.csv).

To run the examples, install Julia and the recorded environment — see
[STUDENT_SETUP.md](STUDENT_SETUP.md), and [INSTALL.md](INSTALL.md) for common
installation problems (for example, telling VS Code where Julia is), plus the
[Julia and VS Code FAQ](FAQ.md). If Git is
not installed, use the repository's **Code → Download ZIP** button instead of
cloning. The notebooks under
`week-N/notebooks/` are optional interactive companions; each one already carries
its saved outputs. They read their data from `assets/data/` and their figures from
`assets/figures/`. You can keep your own scripts outside this folder; see
*Working from your own folder* in [STUDENT_SETUP.md](STUDENT_SETUP.md) for how to
use the course environment and data from anywhere.

## Layout

```
classnotes/notes-{en,he,ar}/main.pdf          lecture book
recitations/recitation-{en,he,ar}/main.pdf     recitation book
further-reading/                               optional self-study companion
week-0-intro/  week-1/ … week-7/             per-week materials
    presentation/        Reveal slides (English, Hebrew)
    HWn-{lang}.pdf        released homework assignments (Weeks 1–7)
    Bonusn-{lang}.pdf     optional bonus assignment
    notebooks/            lecture_nn-{lang}.ipynb, recitation_nn-{lang}.ipynb
assets/figures/  assets/data/                  figures and CSV data
examples/                                      runnable Julia example scripts
reference/julia-cheatsheet.pdf                  four-page semester reference
Project.toml  Manifest.toml  STUDENT_SETUP.md  verify_environment.jl
```
