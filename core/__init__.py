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
