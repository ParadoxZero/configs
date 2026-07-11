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
        self.cargo_deps += ['impala', 'waycal', 'ripgrep', 'fd-find']

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
            # "libinput-gestures",
            "libgtk-4-dev",
            "libgtk4-layer-shell-dev",
            "pkg-config",
            "jq",
            "tree",
            "tmux"
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
        self.__print_manual_deps_help()
        return super().install_dependencies()

    def __print_manual_deps_help(self):
        # Desktop and dev tools are intentionally not auto-installed:
        # this script also provisions headless Ubuntu server dev envs.
        output.Info("The following are referenced by configs but must be installed manually:")
        print("""
Desktop (Sway) stack — skip on servers:
    sudo apt install sway waybar swaylock swayidle sway-notification-center \\
        fuzzel grim slurp wl-clipboard wlogout autotiling mate-polkit kitty alacritty
    swayosd  — apt on Ubuntu 24.10+/Debian trixie, else build from https://github.com/ErikReider/SwayOSD
    swtchr   — cargo install --git https://github.com/justlark/swtchr swtchr
    bluetui  — cargo install bluetui

Dev tools — managed via Mason inside nvim (:Mason), do not apt-install:
    clangd, pyright, emmylua_ls
    gdb      — sudo apt install gdb (only if debugging locally)

Optional:
    microk8s — sudo snap install microk8s --classic (only for the kubectl alias)

Run `python configure.py --check` to see what is currently missing.""")

    @override
    def required_binaries(self) -> list[tuple[str, str, str]]:
        return super().required_binaries() + [
            ("sqlite3", "core", "apt install sqlite3"),
            ("jq", "core", "apt install jq"),
            ("tmux", "core", "apt install tmux"),
            ("clang", "core", "apt install clang"),
            ("sway", "desktop", "apt install sway"),
            ("waybar", "desktop", "apt install waybar"),
            ("swaylock", "desktop", "apt install swaylock"),
            ("swayidle", "desktop", "apt install swayidle"),
            ("swaync", "desktop", "apt install sway-notification-center"),
            ("swayosd-server", "desktop", "apt install swayosd, or build https://github.com/ErikReider/SwayOSD"),
            ("swtchr", "desktop", "cargo install --git https://github.com/justlark/swtchr swtchr"),
            ("fuzzel", "desktop", "apt install fuzzel"),
            ("grim", "desktop", "apt install grim"),
            ("slurp", "desktop", "apt install slurp"),
            ("wl-copy", "desktop", "apt install wl-clipboard"),
            ("wlogout", "desktop", "apt install wlogout"),
            ("autotiling", "desktop", "apt install autotiling"),
            ("libinput-gestures", "desktop", "apt install libinput-gestures"),
            ("kitty", "desktop", "apt install kitty"),
            ("alacritty", "desktop", "apt install alacritty"),
            ("bluetui", "desktop", "cargo install bluetui --locked"),
            ("impala", "desktop", "cargo install impala --locked"),
            ("waycal", "desktop", "cargo install waycal --locked"),
            ("gdb", "dev", "apt install gdb"),
            ("clangd", "dev", "install via Mason in nvim"),
            ("pyright", "dev", "install via Mason in nvim"),
            ("emmylua_ls", "dev", "install via Mason in nvim"),
            ("microk8s", "dev", "sudo snap install microk8s --classic (kubectl alias)"),
        ]
