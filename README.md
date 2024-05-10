# Generic Python Template
This is a generic template for smaller python projects. This project should not be cloned, but used with the `Use this template` button on github. 

The following tools are used for development and building:
- **Linting and formatting** - using [ruff](https://astral.sh/ruff)
- **Virtual environment** - not required but recommended to use [uv](https://github.com/astral-sh/uv)
- **build system** - [build](https://pypi.org/project/build/)
- **Testing** - [pytest](https://pypi.org/project/pytest/)
- **pre-commit** - [pre-commit](https://pre-commit.com/), see config in `.pre-commit-config.yaml`, currently only `ruff` for formatting and linting.
- **Release** - [release-please](https://github.com/googleapis/release-please)


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
````

### CICD
Set up for building and publishing on github using [release-please](https://github.com/googleapis/release-please), meaning [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) are required.
