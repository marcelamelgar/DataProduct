from fastapi import FastAPI
from enum import Enum

app = FastAPI()

DESCRIPTIONS = {
    "alexnet": "you selected alexnet model.",
    "resnet": "you selected resnet server model.",
    "lenet": "you selected lenet server model."
}

class ModelName(str, Enum):
    alexnet = "alexnet"
    resnet = "resnet"
    lenet = "lenet"

@app.get("/")
async def root():
    return {"message": "hello world, grom UFM 2022!"}

@app.get("/items/{item_id}")
async def read_item(item_id:int):
    return {"item_id":item_id}

@app.get("/users/me")
async def read_user_me():
    return{"user_id": "the current user"}

@app.get("/users/{user_id}")
async def read_user(user_id: str):
    return{"user_id": user_id}

@app.get("/models/{model_name}")
async def get_model_data(model_name: ModelName):
    return {"model": model_name, "description":DESCRIPTIONS[model_name]}
