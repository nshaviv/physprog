# Julia and VS Code FAQ

For step-by-step checks, see [Julia and VS Code: installation help](INSTALL.md).

## Do I need to install Julia to read the course material?

No. You can read the books and assignments without installing anything. Julia
and the notebooks are optional ways to run and explore the examples.

## What is the difference between the Julia version and the project environment?

The Julia version is the executable that runs your code, such as Julia 1.12 or
1.13. The project environment is the set of packages Julia can load, such as
the course environment named `physprog`. You can use Julia 1.12 with the
`physprog` environment; choosing one does not automatically choose the other.

## Why does VS Code need a folder open?

Opening the course folder lets VS Code and the Julia extension find the course
`Project.toml`, workspace settings, and files together. Choose **File → Open
Folder** and select the folder containing the course files, rather than opening
only one `.jl` file.

## VS Code cannot find Julia. What should I check?

Open **Preferences: Open Settings (UI)** from the Command Palette and search for
**Julia: Executable Path**. Check both User and Workspace settings; the workspace
can override the user value. On Windows with Juliaup, the Juliaup launcher is
often at
`C:\Users\YourName\AppData\Local\Microsoft\WindowsApps\julia.exe`.
Replace `YourName` with your Windows account folder name and confirm the path
exists. More details are in the
[installation help](INSTALL.md#select-julia-112).

## Should I use Julia 1.12 or 1.13?

The course examples use Julia 1.12. If you have trouble with Julia 1.13, try
installing 1.12 with `juliaup add 1.12` and selecting it in VS Code. Setting
`juliaup default 1.12` changes the default for the Juliaup launcher, while an
explicit executable path in VS Code can still point to another version.

## How can I tell which Julia the language server is using?

Choose **View → Output**, then select **Julia Language Server**. Read the
startup messages for the Julia version or executable path. If that version
differs from the one in **Julia: Executable Path**, check for a Workspace
override and reload VS Code. See the
[language-server troubleshooting notes](INSTALL.md#when-the-language-server-starts-with-a-different-julia-version).

## Julia shows an “Application Control” error on Windows 11. What now?

Check **Windows Security → App & browser control → Smart App Control** to see
whether Julia was blocked. On a managed computer, ask IT support before
changing security settings. Confirm that Julia was installed from the official
source.

## What should I include when I ask for help?

Include what you were trying to do, the exact error message, your Julia version,
and relevant lines from **View → Output → Julia Language Server**. Remove your
Windows account name or other private details from copied paths first. You can
also ask a programming assistant to interpret the messages after removing
private details.
