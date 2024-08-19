# Build stage
FROM python:3.12-slim-bullseye as build

WORKDIR /app

COPY pyproject.toml /app/

COPY --from=ghcr.io/astral-sh/uv:0.2.37 /uv /bin/uv

RUN uv pip install --system --no-cache --upgrade pip setuptools wheel build \
    && uv pip install --system --no-cache -e .

COPY ./src/ /app/

RUN python -m build --outdir ./dist/

# Run stage
FROM python:3.12-slim-bullseye

WORKDIR /app

COPY --from=build /app/dist/*.whl /app/
COPY --from=build /bin/uv /bin/uv

RUN uv pip install --system /app/*.whl

CMD ["python", "-m", "my_project"]