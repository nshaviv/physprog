# Physics Programming — student materials (77641)

Student materials for the first-year course **77641 Physics Programming
(Julia + Python)**: the orientation chapter and Weeks 1–3. English is the default;
the books and assignments are also available in Hebrew and Arabic, and the slides
in English and Hebrew.

## Start here

You can read everything with no software installed.

- **Read the lecture book:** [`classnotes/notes-en/main.pdf`](classnotes/notes-en/main.pdf)
  (also [עברית](classnotes/notes-he/main.pdf) · [العربية](classnotes/notes-ar/main.pdf)).
- **Homework and bonus:** `week-N/HW{N}-{lang}.pdf`, `week-N/Bonus{N}-{lang}.pdf`.
  Homework is submitted on the course **Moodle** page.
- **Slides:** `week-N/presentation/`.
- **Recitation book:** `recitations/recitation-{lang}/main.pdf`.

There is a one-page web index with the same links at
[nshaviv.github.io/physprog](https://nshaviv.github.io/physprog/).

## Running the code (optional)

To run the examples, install Julia and the recorded environment — see
[STUDENT_SETUP.md](STUDENT_SETUP.md). If Git is not installed, use the repository's
**Code → Download ZIP** button instead of cloning. The notebooks under
`week-N/notebooks/` are optional interactive companions; each one already carries
its saved outputs. They read their data from `assets/data/` and their figures from
`assets/figures/`.

## Layout

```
classnotes/notes-{en,he,ar}/main.pdf          lecture book
recitations/recitation-{en,he,ar}/main.pdf     recitation book
further-reading/                               optional self-study companion
week-0-intro/  week-1/  week-2/  week-3/       per-week materials
    presentation/        Reveal slides (English, Hebrew)
    HWn-{lang}.pdf        homework assignment (Week 1 onward)
    Bonusn-{lang}.pdf     optional bonus assignment
    notebooks/            lecture_nn-{lang}.ipynb, recitation_nn-{lang}.ipynb
assets/figures/  assets/data/                  figures and CSV data
Project.toml  Manifest.toml  STUDENT_SETUP.md  verify_environment.jl
```
