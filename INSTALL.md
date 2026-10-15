# Julia and VS Code: installation help

This page collects fixes that helped when students had trouble getting Julia to
work in Visual Studio Code. Similar symptoms can have different causes, so try
the checks below and note any error message you see. For short answers to common
questions, see the [installation FAQ](FAQ.md).

## Open the course folder and trust it

Open a folder rather than only an individual `.jl` file. In VS Code, choose
**File → Open Folder** and select the folder containing your Julia files. For
this course, open the downloaded or cloned `physprog` folder—the one containing
`Project.toml`.

If VS Code asks whether you trust the folder's authors, choose **Trust** only
when the files are yours or come from a source you trust. In Restricted Mode,
some extensions and workspace features may not start. You can check the current
mode from the VS Code window or the workspace-trust prompt.

## Restart VS Code or the Julia language server

An extension restart or a VS Code reload can clear a temporary startup problem.
Open the Command Palette with **Ctrl+Shift+P** (Windows/Linux) or
**Cmd+Shift+P** (macOS), then run:

- **Developer: Reload Window** to reload VS Code.
- **Julia: Restart Language Server** to restart the Julia language server, if
  that command is available.

Closing the VS Code window and opening the course folder again is another way to
reload it.

## Select Julia 1.12

The course uses Julia 1.12. If Julia 1.13 is causing trouble, install Julia 1.12
through Juliaup in a terminal:

```powershell
juliaup add 1.12
juliaup default 1.12
julia --version
```

The default setting affects commands that start the unqualified `julia`
launcher. VS Code can still use a separately configured executable, so check
its setting too.

In VS Code, open **Preferences: Open Settings (UI)** from the Command Palette
and search for **Julia: Executable Path** (`julia.executablePath`). If it points
directly to a Julia 1.13 installation, select the installed Julia 1.12
executable instead. Check both **User** and **Workspace** settings; a workspace
setting can override the user setting.

On Windows with Juliaup, you can usually configure VS Code to use Juliaup's
launcher. In `settings.json`, use the path for your Windows account:

```json
{
  "julia.executablePath": "C:\\Users\\YourName\\AppData\\Local\\Microsoft\\WindowsApps\\julia.exe"
}
```

Replace `YourName` with your Windows account folder name, and confirm that the
file exists. After changing the path, run **Developer: Reload Window**.

## Choose the course environment

The Julia version and the active project environment answer different
questions. The version selects which Julia executable runs; the environment
selects which package set Julia uses. For example, you can run Julia 1.12 while
the active project is `physprog`.

Look for the Julia environment indicator in the VS Code status bar. Click it to
choose the course project—the folder containing the course `Project.toml`. If
packages such as `CSV` cannot be loaded, open a terminal in that folder and run:

```powershell
julia +1.12 --project=. -e "using Pkg; Pkg.instantiate()"
```

Then restart the Julia REPL. More detail is in
[Get the course files and run Julia](STUDENT_SETUP.md).

## When the language server starts with a different Julia version

To see which Julia executable the language server is using, choose **View →
Output**, then select **Julia Language Server** in the output list. Look for the
startup message that names its Julia version or executable path.

If the log reports Julia 1.13 while the extension is set to Julia 1.12, recheck
the User and Workspace executable-path settings, then reload VS Code. One
reported setup began working after its executable path was changed back to
Julia 1.13. Treat that as a case-specific diagnostic workaround, not a general
recommendation: verify which version the course REPL actually starts before
continuing, and note the language-server log when asking for help.

## Windows 11: “Application Control” blocked Julia

If Windows shows an **Application Control** error when Julia starts, check
whether Windows Security's **Smart App Control** is blocking the application.
Open **Windows Security → App & browser control → Smart App Control** and read
its status. On a school-managed computer, ask the administrator or IT support
before changing security settings. Avoid turning off a protection feature just
to get Julia running; first confirm that Julia came from the official Julia
installation source.

## A useful order for troubleshooting

If Julia still will not start in VS Code, try these steps in order:

1. Open the course folder and trust it if it is from a source you trust.
2. Reload the VS Code window; restart the Julia language server if needed.
3. Check **Julia: Executable Path**, including any Workspace override.
4. Select the course project environment in the status bar.
5. Try Julia 1.12 if you are currently using Julia 1.13.
6. Read **View → Output → Julia Language Server** for the version and error
   details. Those messages can help you or course staff diagnose the problem.

If you ask for help, include the exact error text and the relevant language
server output. Remove personal paths or other private information first.
You can also ask a programming assistant to interpret the messages; share only
the relevant output, with account names, tokens, and other private details
removed.
