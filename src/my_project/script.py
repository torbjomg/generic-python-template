from importlib import metadata


def get_version():
    return metadata.version("project-name")


def my_function():
    version = get_version()
    print(f"Hello from my_project v{version}!")
