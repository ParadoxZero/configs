import enum
import platform
s
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

    def install_dependencies(self) -> bool:
        raise NotImplementedError()


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
    def install_dependencies(self) -> bool:
        deps = [
            "winget install  Nushell.Nushell",
            "winget install Neovim.Neovim",
            "winget install BurntSushi.ripgrep.MSVC",
            "winget install junegunn.fzf",
            "winget install ajeetdsouza.zoxide",
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
        return True


class Linux(OS):
    def __init__(self) -> None:
        config_dir = Path.home() / ".config"
        super().__init__(OSType.LINUX, config_dir)

    def __install_nushell(self):
        output.Info("Installing nushell ...")
        nushell_repo_key = Path("/etc/apt/keyrings/fury-nushell.gpg").resolve()
        if not nushell_repo_key.exists():
            result = Run(
                "wget -qO- https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/fury-nushell.gpg")
            if not result:
                output.Bad("Failed to fetch nushell repo signing key")
                return False
            result = Run(
                "echo \"deb [signed-by=/etc/apt/keyrings/fury-nushell.gpg] https://apt.fury.io/nushell/ /\" | sudo tee /etc/apt/sources.list.d/fury.list")
            if not result:
                output.Bad("Failed to configure nushell repo")
                return False
        result = Run("sudo apt update")
        result = Run("sudo apt install nushell")
        if not result:
            output.Bad("Failed to install nushell.")
            return False
        result = Run("sudo chsh -s /usr/bin/nu")
        if not result:
            output.Info("Failed to set nushell as the login shell.")
            output.Info("Non-fatal failure, continuing...")
        return True

    def __install_lazygit(self):
        output.Info("Fetching latest version of lazygit")
        latest_lazygit = requests.get(
            "https://api.github.com/repos/jesseduffield/lazygit/releases/latest").json()
        tag_name = latest_lazygit["tag_name"].lstrip("v")
        output.Info(f"Found - lazygit v{tag_name}")
        output.Info(f"Downloading lazygit to ~/toolchain")
        download_root = Path.home() / "toolchain"
        download_root.mkdir(exist_ok=True)
        lazygit_archive_path = download_root / f"lazygit-{tag_name}.tar.gz"
        if not lazygit_archive_path.exists():
            url = f"https://github.com/jesseduffield/lazygit/releases/download/v{tag_name}/lazygit_{tag_name}_Linux_x86_64.tar.gz"
            r = requests.get(url, stream=True)
            with open(lazygit_archive_path, "wb") as f:
                for chunk in r.iter_content(8192):
                    f.write(chunk)
        else:
            output.Info("Latest lazygit already downloaded ...Skiping")

        output.Info("Extracting lazygit")
        if not Run(f"tar xf {lazygit_archive_path} lazygit"):
            output.Bad("Failed to extract Lazygit. Install Manually...")
            return
        output.Info("Placing lazygit")
        if not Run(f"sudo install {download_root / "lazygit"} -D -t /usr/local/bin"):
            output.Bad("Failed to place lazygit")
            return
        output.Good("Installed Lazygit")

    @override
    def install_dependencies(self) -> bool:
        deps = [
            "fzf",
            "ripgrep",
            "zoxide",
            "rustup",
            "sqlite3",
            "bat"
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
        if not Run("zoxide init nushell | save -f ~/.zoxide.nu"):
            output.Bad("Failed to init zoxide")
            return False
        self.__install_nushell()
        self.__install_lazygit()
        output.Good("Installing dependencies ...OK")
        return True


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
            "zoxide",
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
            
        if not Run("zoxide init nushell | save -f ~/.zoxide.nu"):
            output.Bad("Failed to init zoxide")
            return False

        output.Good("Installing dependencies ...OK")
        return True


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
