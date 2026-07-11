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
