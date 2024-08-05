# Generic Python Template
This is a generic template for smaller python projects. This project should not be cloned, but used with the `Use this template` button on github. 

The following tools are used for development and building:
- **Linting and formatting** - using [ruff](https://astral.sh/ruff)
- **Virtual environment** - not required but recommended to use [uv](https://github.com/astral-sh/uv)
- **build system** - [build](https://pypi.org/project/build/)
- **Testing** - [pytest](https://pypi.org/project/pytest/)
- **pre-commit** - [pre-commit](https://pre-commit.com/), see config in `.pre-commit-config.yaml`, currently only `ruff` for formatting and linting.
- **Release** - [release-please](https://github.com/googleapis/release-please)

## Project Structure

This project follows a standard Python project structure, which is important for building and distributing the project. Here's a brief overview:

- `src/`: This is where the source code of the project resides. The `src/` directory contains a subdirectory that should be renamed to your project name. This subdirectory will contain your Python modules and packages.

    - `my_project/`: This is the main package of your project. Rename this to your project name. It contains the main script (`script.py`) and the main entry point (`__main__.py`).

        - `script.py`: This is a placeholder script. Replace this with your own code.

        - `__main__.py`: This is the entry point when running the project with `python -m`. It currently references `script.py`, so make sure to update this if you replace `script.py`.

- `tests/`: This directory contains test files. The template only contains a dummy test.

- `pyproject.toml`: This file contains metadata about the project and its dependencies. Update this with your project name, description, author, and dependencies.

- `requirements.txt`: This file should contain the pinned versions of your dependencies. It's recommended to keep unpinned requirements in `pyproject.toml` and pin them to `requirements.txt` on release.

- `.github/workflows/`: This directory contains GitHub Actions workflows for continuous integration and deployment. The workflows handle testing (`ci.yml`), release creation (`release-please.yml`).

Build your project with `python -m build --outdir ./dist/` and install it from the `.whl` file in your virtual environment. You can then run your project with `python -m my_project`, replacing `my_project` with your project name.

### Virtual environment
`uv` is a fast package installer and a drop-in replacement for `pip`. Should be installed on your system first using this command: 

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```
Create a virtual env and activate it (when in this root folder)

```bash
uv venv venv -p python3.11
source venv/bin/activate
```

Use as you would `pip`, but prefix commands with `uv`, i.e:
```bash
# single package
uv pip install pandas
# from requirements file
uv pip install -r requirements.txt
# from pyproject dependencies
uv pip install -e '.[dev]'
```

Recommended to keep unpinned requirements in `pyproject.toml` under `[dependencies]` on this format
```toml
dependencies = [
    "pandas",
    "fastapi",
]
```
And pinning requirements to `requirements.txt` on release with 
```bash
uv pip freeze > requirements.txt
```

### First steps
After creating a new repo based on this template there are a few steps to take before starting development of your project:
1. Update `pyproject.toml` with project name, description, author. Optionally define dependencies.
2. Rename the folder `src/my_project` to the same as your project name (with underscores instead of hyphens)
3. Replace the placeholder `src/my_project/script.py` and references to it in `src/my_project/__main__.py`
4. If you want to use release-please, set up a PAT for this repo and name it `RELEASE_PLEASE_PAT`
5. Verify pre-commit works by running `pre-commit run --all-files`. `ruff` and `ruff-format` should run and pass.
   

The `__main__.py` is the app entry point when running the project from `python -m`. You can test this by first building your project and installing from the `.whl` file (assuming you have followed the above steps and are in your virtual environment)
```bash
(venv) python -m build --outdir ./dist/
(venv) uv pip install ./dist/*.whl
(venv) python -m my_project # replace this with your project name if you've changed it
# Hello from my_project v0.1.0!
```

### Tests
The project has some dummy tests to check that you can correctly import the source code. To run, first the test requirements need to be installed: (the test requirements is already included in the dev requirements, so this is not required if you have installed dev requirements)
```bash
uv pip install -e '.[test]'
```
And run the tests:
```bash
pytest tests/
# 2 tests should run and pass
```

### Docker
This project comes with a Dockerfile and docker-compose templates for run/test/dev. Requires docker to be installed on your system. To build the image
```bash
docker build -t generic-python-template .
```
And to run the built image
```bash
docker run generic-python-template
# Hello from my_project v0.1.0!
```
Note that the Dockerfile is a multi-stage build which first builds the project whl, then installs and runs it in the run stage. The final `CMD` statement will need to be updated with your project name.

Also note that the `Dockerfile` currently installs requirements from the `pyproject.toml` file, not the `requirements.txt`.

#### Docker Compose
There is also a docker compose file where you can add additional services (currently template just runs the base Dockerfile), and a `docker-compose.test.yaml` which can be used to run tests, either locally or in a CICD pipeline.

To run docker compose:
```bash
docker compose up --build
```

To run the test docker compose:
```bash
docker compose -f docker-compose.test.yaml up --build
```

Note that the docker-compose.test.yaml installs the base image and mounts the test files. Test files will also need to be available in CICD pipeline.

### CICD
Set up for building and publishing on github using [release-please](https://github.com/googleapis/release-please), meaning [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) are required.

#### Workflows
- **ci.yml** - runs pytest. Required check for the following workflows.
- **release-please.yml** - creates the release PR, handles semantic versioning.
- **publish-release.yml** - builds the project and publishes release to github releases.