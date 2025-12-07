import enum
import platform
from pathlib import Path
from typing import override

from tools.shell import Result, Run
import tools.output as output

class OSType(enum.Enum):
    WIN = 1
    LINUX = 2
    MACOS = 3


class OS:
    def __init__(self, type:OSType, config_dir: Path) -> None:
        self.Type = type
        self.ConfigDir = config_dir

    def type(self):
        return self.Type

    def name(self):
        return  platform.system()     

    def get_nvim_path(self):
        return self.ConfigDir / "nvim"

    def get_nushell_path(self):
        return self.ConfigDir / "nushell"

    def get_tmux_conf_path(self):
        return Path.home() / ".tmux.conf"

    def install_dependencies(self)->bool:
        raise NotImplementedError()

class Win(OS):
    def __init__(self):
        config_dir: Path = Path.home() / "AppData" / "local"
        super().__init__(type=OSType.WIN, config_dir= config_dir)

    @override
    def get_nushell_path(self):
        return Path.home() / "AppData" / "Roaming" / "nushell"

    @override
    def get_tmux_conf_path(self):
        raise ValueError("Tmux isn't available on windows")

    @override
    def install_dependencies(self)->bool:
        raise NotImplementedError()
    
class Linux(OS):
    def __init__(self ) -> None:
        config_dir = Path.home() / ".config"
        super().__init__(OSType.LINUX, config_dir)

    def __install_nushell(self):
        output.Info("Installing nushell ...")
        nushell_repo_key = Path("/etc/apt/keyrings/fury-nushell.gpg").resolve()
        if not nushell_repo_key.exists():
            result = Run("wget -qO- https://apt.fury.io/nushell/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/fury-nushell.gpg")
            if not result:
                output.Bad("Failed to fetch nushell repo signing key")
                return False
            result = Run("echo \"deb [signed-by=/etc/apt/keyrings/fury-nushell.gpg] https://apt.fury.io/nushell/ /\" | sudo tee /etc/apt/sources.list.d/fury.list")
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

    @override
    def install_dependencies(self) -> bool:
        deps = [
                "fzf",
                "ripgrep",
                "zoxide",
                "rustup",
        ]
        output.Info("Installing dependencies ...Start")
        if not Run("sudo apt update"):
            return False
        result = Run(f"sudo apt install {" ".join(deps)}" )
        if not result:
            output.Bad("Failed to install main deps" )
            return False
        result = Run(f"rustup toolchain install stable")
        if not result:
            output.Bad("Failed to install rust toolchain")
            return False
        if not self.__install_nushell():
            return False
        output.Good("Installing dependencies ...OK")
        return True

def get_os()-> OS:
    os_name = platform.system()
    if os_name == "Windows":
        return Win()
    elif os_name == "Linux":
        return Linux()
    elif os_name == "Darwin":
        raise NotImplementedError("MacOS implementation pending")
    else:
        raise ValueError("Runnin in unsupported platform")
