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
