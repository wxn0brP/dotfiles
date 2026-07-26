# glob Scripts

This directory contains various utility scripts that are available globally when `glob` is added to the PATH.

## Script Descriptions

### add_berg

Adds a `berg` remote pointing to the Codeberg mirror of a GitHub repository and pushes tags.

Usage: `add_berg` (run inside a git repo with a GitHub `origin` remote)

### apply-pr

Fetches and applies diffs from open Renovate pull requests on the current GitHub repository using the GitHub API.

Usage: `apply-pr` (requires `GITHUB_TOKEN` or `GH_TOKEN` for higher rate limits)

### bundle_files

Bundles multiple files into a single output file with annotated file paths, using glob patterns.

Usage: `bundle_files <output_file> <input_patterns...>` or `bundle_files <input_patterns...> -o <output_file>`

### cct

Generates a filtered Cloudflare Tunnel config from a `config-make.yml` template and starts the tunnel. Filters ingress rules by service subdomain. Pass a port number to override the `f` (forward) service.

Usage: `cct <service...> [port]`

### copy_mit

Copies the MIT license to the current directory.

Usage: `copy_mit`

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

### ksctl (systemctl + journalctl) & ksorc (OpenRC)

Wrapper around `systemctl` and `journalctl` / `rc-service` with short operation shortcuts.

Usage: `ksctl <unit> <operation> [args...]`
Usage: `ksorc <unit> <operation> [args...]`

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

### nitf

Initializes a new **frontend** TypeScript project with interactive prompts for optional features (suglite server, SCSS, flanker-ui, gen.js).

Usage: `nitf <directory_name> [package_name]`

### nitl

Initializes a new **library** TypeScript project with build pipeline (tsc + tsc-alias) and GitHub CI workflow.

Usage: `nitl <directory_name> [package_name]`

This is what the `nit` alias points to (defined in `.vars`).

### nits

Initializes a new **server** TypeScript project with interactive prompts for optional modules (database via Valthera, FalconFrame).

Usage: `nits <directory_name> [package_name]`

### nsv

Bumps the npm package version using `standard-version`. Supports alpha (`a`), beta (`b`), patch (`p`), and minor (`m`) releases with optional increment and dry-run mode.

Usage: `nsv [a|b|p|m] [increment] [-d]`

### viol

Moves files into a specified category directory within the Violet Archive (`~/VioletArchive`).

Usage: `viol <category> <file/s>`

### viol-gui

A GUI wrapper for the `viol` script that allows selecting a category from a list to move files into the Violet Archive.

Usage: `viol-gui <file_path>`
