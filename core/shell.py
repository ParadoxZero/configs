import subprocess

class Result:

    def __init__(self, code:int = 0, output:str = "") -> None:
        self.Code = code
        self.Output = output

    def __bool__(self):
        return self.Code == 0

def Run(command: str, capture_output:bool = False) -> Result:
    print(f"▶️{command}")
    result = subprocess.run(command, shell=True, capture_output=capture_output)
    output = ""
    if capture_output:
        output: str = str(result.stdout) + "\n" + str(result.stderr)
    return Result(result.returncode, output = output)
