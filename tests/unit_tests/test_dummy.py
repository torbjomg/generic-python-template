from my_project.script import get_version


def test_dummy():
    assert True


def test_get_version():
    assert get_version() == "0.1.0"
