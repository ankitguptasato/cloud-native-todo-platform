from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import text
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError

from . import models, schemas
from .database import Base, engine, get_db

app = FastAPI(
    title="Todo API",
    description="Sample full-stack backend for the React + Postgres demo",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def on_startup() -> None:
    Base.metadata.create_all(bind=engine)


@app.get("/api/health/live")
def liveness():
    return {"status": "alive"}


@app.get("/api/health/ready", response_model=schemas.HealthOut)
@app.get("/api/health", response_model=schemas.HealthOut)
def readiness(db: Session = Depends(get_db)) -> schemas.HealthOut:
    try:
        db.execute(text("SELECT 1"))
    except SQLAlchemyError as exc:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Database unavailable",
        ) from exc

    return schemas.HealthOut(
        status="ok",
        database="connected",
    )


@app.get("/api/todos", response_model=list[schemas.TodoOut])
def list_todos(db: Session = Depends(get_db)) -> list[models.Todo]:
    return db.query(models.Todo).order_by(models.Todo.id.desc()).all()


@app.post(
    "/api/todos",
    response_model=schemas.TodoOut,
    status_code=status.HTTP_201_CREATED,
)
def create_todo(
    payload: schemas.TodoCreate, db: Session = Depends(get_db)
) -> models.Todo:
    todo = models.Todo(title=payload.title.strip())
    db.add(todo)
    db.commit()
    db.refresh(todo)
    return todo


@app.patch("/api/todos/{todo_id}", response_model=schemas.TodoOut)
def update_todo(
    todo_id: int, payload: schemas.TodoUpdate, db: Session = Depends(get_db)
) -> models.Todo:
    todo = db.get(models.Todo, todo_id)
    if not todo:
        raise HTTPException(status_code=404, detail="Todo not found")

    if payload.title is not None:
        todo.title = payload.title.strip()
    if payload.completed is not None:
        todo.completed = payload.completed

    db.commit()
    db.refresh(todo)
    return todo


@app.delete("/api/todos/{todo_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_todo(todo_id: int, db: Session = Depends(get_db)) -> None:
    todo = db.get(models.Todo, todo_id)
    if not todo:
        raise HTTPException(status_code=404, detail="Todo not found")
    db.delete(todo)
    db.commit()
