# Build stage
FROM python:3.12-slim-bullseye as build

WORKDIR /app

COPY pyproject.toml /app/

COPY --from=ghcr.io/astral-sh/uv:0.4.9 /uv /bin/uv

RUN uv pip install --system --no-cache --upgrade pip setuptools wheel build \
    && uv pip install --system --no-cache -e .

COPY ./src/ /app/

RUN python -m build --outdir ./dist/

# Run stage
FROM python:3.12-slim-bullseye

WORKDIR /app

COPY --from=build /app/dist/*.whl /app/

RUN --mount=from=build,source=/bin/uv,target=/bin/uv \
    uv pip install --system /app/*.whl

CMD ["python", "-m", "my_project"]