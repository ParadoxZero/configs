"""
MIT License

Copyright (c) 2025 Sidhin S Thomas

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""
from pathlib import Path
import shutil
from tools.os import OSType, get_os 
import tools.output as output
import argparse

def recursive_link(source_dir: Path, target_dir: Path):
    # Create target is not exists, no-op if already present
    target_dir.mkdir(exist_ok=True, parents=True)
    output.Info(f"Linking  {source_dir} to {target_dir}")
    if target_dir.exists() or target_dir.is_symlink():
        assert(target_dir.is_dir())
        if target_dir.is_symlink():
            output.Info("Unlinking exisiting dir")
            target_dir.unlink()
        else:
            output.Info("Deleting exisiting dir")
            shutil.rmtree(target_dir)

    target_dir.symlink_to(source_dir, target_is_directory=True)

def link(source: Path, target: Path):
    output.Info(f"Linking {source} to {target}")
    if target.exists() or target.is_symlink():
        output.Info("Removing exisiting file.")
        target.unlink()
    target.symlink_to(source)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--skip-deps",
        action="store_true",
        help="Skip installing dependencies"
    )
    args = parser.parse_args()

    os = get_os()
    output.Info(f"Detected platform - {os.name()}")
    if not args.skip_deps:
        if not os.install_dependencies():
            return 
    here = Path(__file__).resolve()
    root = here.parent
    
    output.Info("Configuring nushell")
    recursive_link(root / "configs" / "nushell", os.get_nushell_path())
    output.Good("Configuring nushell ...OK")
    
    output.Info("Configuring NeoVim")
    recursive_link(root / "configs" / "nvim", os.get_nvim_path())
    output.Good("Configuring NeoVim ...OK")
    
    if os.Type != OSType.WIN:
        output.Info("Configuring Tmux")
        link(root / "configs" / ".tmux.conf", os.get_tmux_conf_path())
        output.Good("Configuring Tmux ...Ok")

if __name__ == "__main__":
    main()
