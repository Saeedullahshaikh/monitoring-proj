from fastapi import FastAPI
import subprocess
from pathlib import Path

app = FastAPI()
REPORT_DIR = Path("/tmp")

@app.get("/reports")
def list_reports():
    files = sorted(REPORT_DIR.glob("cost_report_*"), reverse=True)
    return {"reports": [f.name for f in files]}

@app.get("/reports/{name}")
def get_report(name: str):
    file = REPORT_DIR / name
    if file.exists():
        return file.read_text()
    return {"error": "not_found"}

@app.post("/run")
def manual_run():
    # run shellscript manually
    subprocess.call(["bash", "scripts/optimize.sh"])
    return {"status": "triggered"}
