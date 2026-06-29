#pip install fastapi

from fastapi import FastAPI
from fastapi import HTTPException
import json
import time

app = FastAPI()


@app.get("/iosnoop")
def read_root():
    try:
        with open('/tmp/io_exporter/iosnoop.json', 'r') as iosnoop:
            content = json.load(iosnoop)

            return content
    except:
        raise HTTPException (
            status_code=500,
            detail={ "message": "IO Exporter Not Running Error" }
        )
