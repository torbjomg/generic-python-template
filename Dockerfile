# Build stage
FROM python:3.12-slim as build

WORKDIR /app

COPY pyproject.toml /app/
RUN pip install --upgrade pip setuptools wheel build \
    && pip install -e .

COPY ./src/ /app/

RUN python -m build --outdir ./dist/

# Run stage
FROM python:3.12-slim

WORKDIR /app

COPY --from=build /app/dist/*.whl /app/

RUN pip install /app/*.whl

CMD ["python", "-m", "my_project"]