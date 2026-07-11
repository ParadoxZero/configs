# Core Module Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rename the `tools/` module to `core/` and split the monolithic `tools/os.py` into one file per OS class.

**Architecture:** Create a new `core/` package with `base.py` (shared base class), three platform files (`windows.py`, `linux.py`, `macos.py`), and `__init__.py` exposing `get_os()`. Move `shell.py` and `output.py` verbatim. Update `configure.py` imports. Delete `tools/`.

**Tech Stack:** Python 3.12+, stdlib only (pathlib, platform, enum, subprocess). `requests` used in `linux.py` for lazygit/neovim downloads.

---

## File Map

| Action | Path |
|--------|------|
| Create | `core/__init__.py` |
| Create | `core/base.py` |
| Create | `core/windows.py` |
| Create | `core/linux.py` |
| Create | `core/macos.py` |
| Create | `core/shell.py` |
| Create | `core/output.py` |
| Modify | `configure.py` (2 import lines) |
| Delete | `tools/` (entire directory) |

---

## Task 1: Create `core/shell.py` and `core/output.py`

These are copied verbatim — no logic changes.

**Files:**
- Create: `core/shell.py`
- Create: `core/output.py`

- [ ] **Step 1: Create `core/shell.py`**

```python
import subprocess

class Result:

    def __init__(self, code:int = 0, output:str = "") -> None:
        self.Code = code
        self.Output = output

    def __bool__(self):
        return self.Code == 0

def Run(command: str, capture_output:bool = False) -> Result:
    print(f"▶️{command}")
    result = subprocess.run(command, shell=True, capture_output=capture_output)
    output = ""
    if capture_output:
        output: str = str(result.stdout) + "\n" + str(result.stderr)
    return Result(result.returncode, output = output)
```

- [ ] **Step 2: Create `core/output.py`**

```python
def Info(text: str):
    print(f"ℹ️  {text}")

def Good(text: str):
    print(f"✅ {text}")

def Bad(text:str):
    print(f"❌ {text}")
```

- [ ] **Step 3: Verify imports**

```bash
python -c "from core.shell import Run, Result; from core.output import Info, Good, Bad; print('OK')"
```

Expected output: `OK`

- [ ] **Step 4: Commit**

```bash
git add core/shell.py core/output.py
git commit -m "refactor: add core/shell.py and core/output.py"
```

---

## Task 2: Create `core/base.py`

The `OS` base class and `OSType` enum, with imports updated from `tools.*` to `core.*`.

**Files:**
- Create: `core/base.py`

- [ ] **Step 1: Create `core/base.py`**

```python
import enum
import platform
from pathlib import Path
from typing import override

from core.shell import Run
import core.output as output


class OSType(enum.Enum):
    WIN = 1
    LINUX = 2
    MACOS = 3


class OS:
    def __init__(self, type: OSType, config_dir: Path) -> None:
        self.Type = type
        self.ConfigDir = config_dir
        self.cargo_deps = ["tree-sitter-cli", "zoxide", "nu", "bat", "yazi-build", "starship", "carapace-bin", "fnm", "uv"]

    def type(self):
        return self.Type

    def name(self):
        return platform.system()

    def get_nvim_path(self):
        return self.ConfigDir / "nvim"

    def get_nushell_path(self):
        return self.ConfigDir / "nushell"

    def get_tmux_conf_path(self):
        return Path.home() / ".tmux.conf"

    def get_tmux_plugin_path(self):
        return self.ConfigDir / "tmux"

    def get_alacritty_path(self):
        return self.ConfigDir / "alacritty"

    def get_kitty_path(self):
        return self.ConfigDir / "kitty"

    def get_starship_path(self):
        return self.ConfigDir / "starship.toml"

    def install_dependencies(self) -> bool:
        for dep in self.cargo_deps:
            Run(f"cargo install {dep} --locked")
        return True
```

- [ ] **Step 2: Verify import**

```bash
python -c "from core.base import OS, OSType; print('OK')"
```

Expected output: `OK`

- [ ] **Step 3: Commit**

```bash
git add core/base.py
git commit -m "refactor: add core/base.py with OS base class and OSType"
```

---

## Task 3: Create `core/windows.py`

**Files:**
- Create: `core/windows.py`

- [ ] **Step 1: Create `core/windows.py`**

```python
from pathlib import Path
from typing import override

from core.base import OS, OSType
from core.shell import Run
import core.output as output


class Win(OS):
    def __init__(self):
        config_dir: Path = Path.home() / "AppData" / "local"
        super().__init__(type=OSType.WIN, config_dir=config_dir)

    @override
    def get_nushell_path(self):
        return Path.home() / "AppData" / "Roaming" / "nushell"

    @override
    def get_alacritty_path(self):
        return Path.home() / "AppData" / "Roaming" / "alacritty"

    @override
    def get_tmux_conf_path(self):
        raise ValueError("Tmux isn't available on windows")

    @override
    def get_starship_path(self):
        return Path.home() / ".config" / "starship.toml"

    def get_glazewm(self):
        return Path.home() / ".glzr" / "glazewm" / "config.yaml"

    @override
    def install_dependencies(self) -> bool:
        deps = [
            "winget install  Nushell.Nushell",
            "winget install Neovim.Neovim",
            "winget install BurntSushi.ripgrep.MSVC",
            "winget install junegunn.fzf",
            "winget install  Python.Python.3.13",
            "winget install  Rustlang.Rustup --include-unknown",
            "winget install JesseDuffield.lazygit",
            "winget install LLVM.LLVM",
            "winget install sharkdp.bat",
        ]
        for cmd in deps:
            if not Run(cmd):
                output.Bad(f"{cmd}...Failed")
                continue
            output.Good(f"{cmd} ...OK")
        return super().install_dependencies()
```

- [ ] **Step 2: Verify import**

```bash
python -c "from core.windows import Win; print('OK')"
```

Expected output: `OK`

- [ ] **Step 3: Commit**

```bash
git add core/windows.py
git commit -m "refactor: add core/windows.py"
```

---

## Task 4: Create `core/linux.py`

**Files:**
- Create: `core/linux.py`

- [ ] **Step 1: Create `core/linux.py`**

```python
from pathlib import Path
from typing import override
import requests

from core.base import OS, OSType
from core.shell import Run
import core.output as output


class Linux(OS):
    def __init__(self) -> None:
        config_dir = Path.home() / ".config"
        super().__init__(OSType.LINUX, config_dir)
        self.cargo_deps += ['impala', 'waycal']

    def get_sway_path(self):
        return self.ConfigDir / "sway"

    def get_waybar_path(self):
        return self.ConfigDir / "waybar"

    def get_swaylock_path(self):
        return self.ConfigDir / "swaylock"

    def get_swaync_path(self):
        return self.ConfigDir / "swaync"

    def get_libinput_gestures_path(self):
        return self.ConfigDir / "libinput-gestures.conf"

    def __toolchain_dir(self) -> Path:
        d = Path.home() / "toolchain"
        d.mkdir(exist_ok=True)
        return d

    def __install_lazygit(self):
        output.Info("Fetching latest version of lazygit")
        latest_lazygit = requests.get(
            "https://api.github.com/repos/jesseduffield/lazygit/releases/latest").json()
        tag_name = latest_lazygit["tag_name"].lstrip("v")
        output.Info(f"Found - lazygit v{tag_name}")
        toolchain = self.__toolchain_dir()
        lazygit_bin = toolchain / "lazygit"
        lazygit_archive_path = toolchain / f"lazygit-{tag_name}.tar.gz"
        if not lazygit_archive_path.exists():
            output.Info("Downloading lazygit to ~/toolchain")
            url = f"https://github.com/jesseduffield/lazygit/releases/download/v{tag_name}/lazygit_{tag_name}_Linux_x86_64.tar.gz"
            r = requests.get(url, stream=True)
            with open(lazygit_archive_path, "wb") as f:
                for chunk in r.iter_content(8192):
                    f.write(chunk)
        else:
            output.Info("Latest lazygit already downloaded ...Skipping")

        output.Info("Extracting lazygit")
        if not Run(f"tar xf {lazygit_archive_path} -C {toolchain} lazygit"):
            output.Bad("Failed to extract Lazygit. Install Manually...")
            return
        output.Info("Symlinking lazygit to /usr/local/bin")
        if not Run(f"sudo ln -sf {lazygit_bin} /usr/local/bin/lazygit"):
            output.Bad("Failed to symlink lazygit")
            return
        output.Good("Installed Lazygit")

    def __install_neovim(self):
        output.Info("Downloading neovim AppImage")
        toolchain = self.__toolchain_dir()
        nvim_path = toolchain / "nvim.appimage"
        url = "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage"
        r = requests.get(url, stream=True)
        with open(nvim_path, "wb") as f:
            for chunk in r.iter_content(8192):
                f.write(chunk)
        nvim_path.chmod(0o755)
        output.Info("Symlinking nvim to /usr/local/bin")
        if not Run(f"sudo ln -sf {nvim_path} /usr/local/bin/nvim"):
            output.Bad("Failed to symlink neovim")
            return
        output.Good("Installed Neovim")

    @override
    def install_dependencies(self) -> bool:
        deps = [
            "fzf",
            "sqlite3",
            "bat",
            "clang",
            "libinput-gestures",
            "libgtk-4-dev",
            "libgtk4-layer-shell-dev",
            "pkg-config"
        ]
        output.Info("Installing dependencies ...Start")
        if not Run("sudo apt update"):
            return False
        result = Run(f"sudo apt install {' '.join(deps)}")
        if not result:
            output.Bad("Failed to install main deps")
            return False
        result = Run("rustup toolchain install stable")
        if not result:
            output.Bad("Failed to install rust toolchain")
            return False
        self.__install_lazygit()
        self.__install_neovim()
        output.Good("Installing dependencies ...OK")
        return super().install_dependencies()
```

- [ ] **Step 2: Verify import**

```bash
python -c "from core.linux import Linux; print('OK')"
```

Expected output: `OK`

- [ ] **Step 3: Commit**

```bash
git add core/linux.py
git commit -m "refactor: add core/linux.py"
```

---

## Task 5: Create `core/macos.py`

**Files:**
- Create: `core/macos.py`

- [ ] **Step 1: Create `core/macos.py`**

```python
from pathlib import Path
from typing import override

from core.base import OS, OSType
from core.shell import Run
import core.output as output


class MacOS(OS):
    def __init__(self) -> None:
        config_dir = Path.home() / ".config"
        super().__init__(OSType.MACOS, config_dir)

    @override
    def get_nushell_path(self):
        return Path.home() / "Library" / "Application Support" / "nushell"

    @override
    def install_dependencies(self) -> bool:
        if not Run("which brew"):
            output.Bad("Homebrew not found. Please install Homebrew first.")
            return False

        deps = [
            "neovim",
            "nushell",
            "ripgrep",
            "fzf",
            "lazygit",
            "bat",
            "sqlite",
            "rustup"
        ]

        output.Info("Installing dependencies ...Start")
        result = Run(f"brew install {' '.join(deps)}")
        if not result:
            output.Bad("Failed to install deps")
            return False

        result = Run("rustup-init -y")
        if not result:
            output.Info("rustup-init failed or already initialized.")

        result = Run("rustup toolchain install stable")
        if not result:
            output.Bad("Failed to install rust toolchain")
            return False

        output.Good("Installing dependencies ...OK")
        return super().install_dependencies()
```

- [ ] **Step 2: Verify import**

```bash
python -c "from core.macos import MacOS; print('OK')"
```

Expected output: `OK`

- [ ] **Step 3: Commit**

```bash
git add core/macos.py
git commit -m "refactor: add core/macos.py"
```

---

## Task 6: Create `core/__init__.py` with `get_os()` factory

**Files:**
- Create: `core/__init__.py`

- [ ] **Step 1: Create `core/__init__.py`**

```python
import platform

from core.base import OS, OSType
from core.windows import Win
from core.linux import Linux
from core.macos import MacOS


def get_os() -> OS:
    os_name = platform.system()
    if os_name == "Windows":
        return Win()
    elif os_name == "Linux":
        return Linux()
    elif os_name == "Darwin":
        return MacOS()
    else:
        raise ValueError("Running in unsupported platform")
```

- [ ] **Step 2: Smoke-test the full `core` package**

```bash
python -c "from core import get_os, OSType; os = get_os(); print(os.name(), os.Type)"
```

Expected output (on Linux): `Linux OSType.LINUX`

- [ ] **Step 3: Commit**

```bash
git add core/__init__.py
git commit -m "refactor: add core/__init__.py with get_os() factory"
```

---

## Task 7: Update `configure.py` imports and delete `tools/`

**Files:**
- Modify: `configure.py` (lines 26-27)
- Delete: `tools/`

- [ ] **Step 1: Update imports in `configure.py`**

Replace:
```python
from tools.os import OSType, get_os 
import tools.output as output
```

With:
```python
from core import OSType, get_os
import core.output as output
```

- [ ] **Step 2: Verify `configure.py` parses cleanly**

```bash
python -c "import configure; print('OK')"
```

Expected output: `OK`

- [ ] **Step 3: Run a dry-run smoke test**

```bash
python configure.py --skip-deps
```

Expected: symlinks are created (or already exist) with no import errors. Output should start with `ℹ️  Detected platform - Linux`.

- [ ] **Step 4: Delete `tools/`**

```bash
rm -rf tools/
```

- [ ] **Step 5: Verify nothing imports from `tools` anymore**

```bash
grep -r "from tools" . --include="*.py"
grep -r "import tools" . --include="*.py"
```

Expected: no output (zero matches).

- [ ] **Step 6: Final smoke test after deletion**

```bash
python -c "from core import get_os, OSType; os = get_os(); print(os.name())"
```

Expected output: `Linux`

- [ ] **Step 7: Commit**

```bash
git add -A
git commit -m "refactor: rename tools/ to core/, split os.py into per-platform files"
```
