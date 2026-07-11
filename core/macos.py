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
