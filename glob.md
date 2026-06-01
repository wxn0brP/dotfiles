# glob Scripts

This directory contains various utility scripts that are available globally when `glob` is added to the PATH.

## Script Descriptions

### add_berg

Adds a `berg` remote pointing to the Codeberg mirror of a GitHub repository and pushes tags.

Usage: `add_berg` (run inside a git repo with a GitHub `origin` remote)

### bundle_files

Bundles multiple files into a single output file with annotated file paths, using glob patterns.

Usage: `bundle_files <output_file> <input_patterns...>` or `bundle_files <input_patterns...> -o <output_file>`

### create_json

Shell function that creates a JSON object from `key=value` arguments.

Usage: `create_json key1=val1 key2=val2`

### destructure

Copies all files from a source directory to a destination directory without preserving the original directory structure.

Usage: `destructure <source_dir> <destination_dir>`

### gdd

alias for `git diff | tee | wl-copy`

### ghls

Lists the user's GitHub repositories that are public and written in TypeScript, with a configurable limit of 150 repositories.

Usage: `ghls [search_query]`

### goo

Opens the current repository's remote origin URL in the default web browser.

Usage: `goo`

### ing

Links executables defined in the `bin` field of the current project's `package.json` to the `~/.ing` directory, making them globally accessible.

Usage: `ing`

### ingr

Clones and installs a project from the wxn0brP GitHub repositories into `~/.ingr`. It also runs the `ing` script to link executables after installation.

Usage: `ingr [project_name]` - If no project name is provided, it updates all projects.

### ksctl

Wrapper around `systemctl` and `journalctl` with short operation shortcuts.

Usage: `ksctl <unit> <operation> [args...]`

Operations: `s` (status), `r` (restart), `e` (enable), `d` (disable), `t` (stop), `x` (start), `l` (logs), `g` (grep logs)

### kill_port

Kills the process running on a specified port.

Usage: `kill_port <port_number>`

### make_desktop

Creates a `.desktop` file for a given executable using a GUI form. The created file is placed in `~/.local/share/applications`.

Usage: `make_desktop /path/to/executable`

### mp2

Converts an MP4 video file to an MP3 audio file using ffmpeg.

Usage: `mp2 filename.mp4`

### nekofetch

Displays system information using `fastfetch` with a custom configuration and logo.

Usage: `nekofetch`

### nit

Initializes a new TypeScript project with a standard structure and configuration, including `package.json`, `tsconfig.json`, and default files/directories.

Usage: `nit <directory_name> [package_name]`

### viol

Moves files into a specified category directory within the Violet Archive (`~/VioletArchive`).

Usage: `viol <category> <file/s>`

### viol-gui

A GUI wrapper for the `viol` script that allows selecting a category from a list to move files into the Violet Archive.

Usage: `viol-gui <file_path>`
