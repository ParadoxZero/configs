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

    def required_binaries(self) -> list[tuple[str, str, str]]:
        """(binary, group, hint) — group is 'core', 'desktop' or 'dev'.

        Missing 'core' binaries fail `configure.py --check`; the other
        groups are informational (expected to be absent on servers).
        """
        return [
            ("nu", "core", "cargo install nu --locked"),
            ("nvim", "core", "installed by configure.py (AppImage on Linux)"),
            ("starship", "core", "cargo install starship --locked"),
            ("zoxide", "core", "cargo install zoxide --locked"),
            ("carapace", "core", "cargo install carapace-bin --locked"),
            ("fnm", "core", "cargo install fnm --locked"),
            ("fzf", "core", "apt/brew/winget install fzf"),
            ("bat", "core", "cargo install bat --locked"),
            ("rg", "core", "cargo install ripgrep --locked"),
            ("fd", "core", "cargo install fd-find --locked"),
            ("tree", "core", "apt/brew/winget install tree"),
            ("tree-sitter", "core", "cargo install tree-sitter-cli --locked"),
            ("yazi", "core", "cargo install yazi-build --locked"),
            ("uv", "core", "cargo install uv --locked"),
            ("lazygit", "core", "installed by configure.py on Linux, brew/winget elsewhere"),
        ]

    def install_dependencies(self) -> bool:
        for dep in self.cargo_deps:
            Run(f"cargo install {dep} --locked")
        return True
