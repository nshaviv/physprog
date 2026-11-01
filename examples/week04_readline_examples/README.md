# Week 4 readline examples (standalone)

The four `while`-loop examples that read input from the keyboard, from section 2
of `../week04-examples.jl`. They are split into separate files because running
`readline()` examples cell by cell in the editor's REPL (VS Code, Jupyter) needs
an extra Enter and can be confusing. Each file here is a complete script that
reads standard input cleanly.

## Files

| File | What it shows | Sample input |
|---|---|---|
| `class_average_sentinel.jl` | sentinel loop: read grades until `-1`, then print the class average | `85` `90` `-1` |
| `check_positive_20_100.jl` | input validation: keep asking until the number is in range | `15` `50` (15 rejected, 50 accepted) |
| `guess_the_number.jl` | guessing game with hints until the guess is right | keep guessing 1–16 |
| `harmonic_series_time.jl` | while-loop timing: count harmonic-series terms until the sum exceeds a limit (capped at 100,000,000 terms) | `10` (or `20` to see the cap stop it) |

## How to run

From a terminal, inside this directory:

```sh
julia class_average_sentinel.jl
```

You can also open a file in VS Code and run the whole file (not cell by cell).
The scripts are intentionally minimal: they are the same code as in
`week04-examples.jl` section 2, so the lecture examples and the standalone
terminal versions stay in sync.

From the repository root, the same files can be run with a full path, e.g.
`julia examples/week04_readline_examples/class_average_sentinel.jl`. From inside
the `examples` folder you can also `include("week04_readline_examples/<file>.jl")`.
