# Design: Refactor `tools/` → `core/` with per-platform files

**Date:** 2026-07-11  
**Status:** Approved

## Summary

Rename the `tools/` module to `core/` and split the single `tools/os.py` file into per-platform modules. No functional changes — this is a pure structural refactor.

## Motivation

- `tools/` is a vague name that doesn't communicate purpose.
- `tools/os.py` (~254 lines) conflates three OS implementations in one file, making it harder to navigate and extend.
- `core/` is a clear, conflict-free name for internal implementation modules.

## New Module Layout

```
core/
  __init__.py      ← get_os() factory + re-exports OSType
  base.py          ← OS base class + OSType enum
  windows.py       ← Win class
  linux.py         ← Linux class
  macos.py         ← MacOS class
  shell.py         ← moved unchanged from tools/shell.py
  output.py        ← moved unchanged from tools/output.py
```

## File Responsibilities

**`core/base.py`**  
Contains `OSType` enum and `OS` base class with all `get_*_path()` methods and the default `install_dependencies()` implementation (cargo deps loop). No platform-specific logic.

**`core/windows.py`**  
Contains `Win(OS)`. Overrides nushell/alacritty/starship paths to use `AppData`, raises on tmux, adds `get_glazewm()`, overrides `install_dependencies()` with winget commands.

**`core/linux.py`**  
Contains `Linux(OS)`. Adds sway/waybar/swaylock/swaync/libinput path methods, private lazygit/neovim install helpers, overrides `install_dependencies()` with apt + cargo extras.

**`core/macos.py`**  
Contains `MacOS(OS)`. Overrides nushell path to `~/Library/Application Support/nushell`, overrides `install_dependencies()` with brew commands.

**`core/__init__.py`**  
Contains `get_os() -> OS` factory (imports Win, Linux, MacOS from their modules). Re-exports `OSType` so callers can do `from core import OSType` without knowing its internal home.

**`core/shell.py` and `core/output.py`**  
Moved verbatim from `tools/`. No changes to content.

## Changes to `configure.py`

| Before | After |
|--------|-------|
| `from tools.os import OSType, get_os` | `from core import OSType, get_os` |
| `import tools.output as output` | `import core.output as output` |

## Cleanup

Delete `tools/` directory entirely after migration is complete.

## Out of Scope

- No changes to any logic, dependency lists, or path resolution.
- No changes to `configure.py` beyond the two import lines.
- No changes to `init.nu` or any config files under `configs/`.
