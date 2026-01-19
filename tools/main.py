from fastapi import FastAPI
from handlers import restart_pipeline, check_costs

app = FastAPI()

@app.post("/tool/restart-pipeline")
def restart(req: dict):
    return restart_pipeline(req)

@app.post("/tool/check-costs")
def costs(req: dict):
    return check_costs(req)
