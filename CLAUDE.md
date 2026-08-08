# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A cross-platform dotfiles repository for Sidhin S Thomas. It stores configuration files for various CLI tools and window managers, with a Python script that symlinks them into the correct platform-specific locations.

## Commands

Apply all configs (installs deps + creates symlinks):
```sh
python configure.py
```

Skip dependency installation (symlinks only):
```sh
python configure.py --skip-deps
```

Initialize nushell vendor autoload scripts (one-time, run from nushell):
```nu
nu init.nu
```

## Architecture

### Entry point: `configure.py`

Calls into `core/` to detect the platform, optionally installs dependencies, then symlinks each `configs/<tool>/` directory (or individual files) into OS-specific config paths using two helpers:
- `link(source, target)` — symlinks a single file, removing any existing file first
- `recursive_link(source_dir, target_dir)` — removes the target dir/symlink entirely, then symlinks the whole source directory

### `core/` — platform abstraction

`core/base.py` defines the `OS` base class with `get_*_path()` methods for each tool's config location and `OSType` enum. Three per-platform subclasses override paths for their platform:
- `core/windows.py` (`Win`) — `%LOCALAPPDATA%` / `%APPDATA%`, no tmux/kitty, uses GlazeWM
- `core/linux.py` (`Linux`) — `~/.config`, includes Sway + Waybar + Swaylock
- `core/macos.py` (`MacOS`) — `~/.config` (nushell at `~/Library/Application Support/nushell`), brew-based deps

`core/__init__.py` exports `get_os()`, the factory function that returns the correct subclass. `core/shell.py` and `core/output.py` provide subprocess and terminal output helpers.

### Platform-specific tool coverage

| Tool | Linux | macOS | Windows |
|------|-------|-------|---------|
| Nushell | ✓ | ✓ | ✓ |
| Neovim | ✓ | ✓ | ✓ |
| Alacritty | ✓ | ✓ | ✓ |
| Starship | ✓ | ✓ | ✓ |
| Tmux | ✓ | ✓ | — |
| Kitty | ✓ | ✓ | — |
| Sway + Waybar + Swaylock | ✓ | — | — |
| GlazeWM | — | — | ✓ |

### `init.nu`

A one-time Nushell script that generates vendor autoload files for: zoxide, carapace, starship, and fnm. Each tool is checked with `which` before attempting generation — missing tools are skipped with a warning.

### `configs/`

Contains the actual config files per tool. Editing files here is how you make config changes — the symlinks mean changes take effect immediately without re-running `configure.py`.

### Dependency notes

- Linux installs via `apt` + cargo. The `core/` code is stdlib-only — no third-party Python deps. The lazygit/neovim GitHub-release installers are currently commented out in `core/linux.py`; if re-enabled they use `curl` + `jq`, both already in the apt dep list.
- macOS installs via Homebrew
- Windows installs via `winget`
- Cargo deps (all platforms): `tree-sitter-cli`, `zoxide`, `nu`, `eza`, `yatzi`, `bat`
