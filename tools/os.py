import enum
import platform
from pathlib import Path
from typing import override
import requests

from tools.shell import Run
import tools.output as output


class OSType(enum.Enum):
    WIN = 1
    LINUX = 2
    MACOS = 3


class OS:
    def __init__(self, type: OSType, config_dir: Path) -> None:
        self.Type = type
        self.ConfigDir = config_dir
        self.cargo_deps = [ "tree-sitter-cli", "zoxide", "nu", "bat", "yazi-build", "starship", "carapace-bin", "fnm", "uv",]

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
        result = Run(f"sudo apt install {" ".join(deps)}")
        if not result:
            output.Bad("Failed to install main deps")
            return False
        result = Run(f"rustup toolchain install stable")
        if not result:
            output.Bad("Failed to install rust toolchain")
            return False
        self.__install_lazygit()
        self.__install_neovim()
        output.Good("Installing dependencies ...OK")
        return super().install_dependencies()


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
        result = Run(f"brew install {" ".join(deps)}")
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


def get_os() -> OS:
    os_name = platform.system()
    if os_name == "Windows":
        return Win()
    elif os_name == "Linux":
        return Linux()
    elif os_name == "Darwin":
        return MacOS()
    else:
        raise ValueError("Runnin in unsupported platform")
