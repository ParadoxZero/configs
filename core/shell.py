import subprocess

class Result:

    def __init__(self, code:int = 0, output:str = "") -> None:
        self.Code = code
        self.Output = output

    def __bool__(self):
        return self.Code == 0

def Run(command: str, capture_output:bool = False) -> Result:
    print(f"▶️{command}")
    result = subprocess.run(command, shell=True, capture_output=capture_output, text=True)
    output = ""
    if capture_output:
        output: str = (result.stdout or "") + (result.stderr or "")
    return Result(result.returncode, output = output)
