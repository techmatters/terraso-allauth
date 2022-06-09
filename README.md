
# Terraso django-allauth provider

Pluggable [Django](https://www.djangoproject.com/) app to add [Terraso](https://terraso.org) as a provider to [django-allauth](https://django-allauth.readthedocs.io/en/latest/).

## Installation

Install the latest version of the `terraso-allauth` package running:

```sh
pip install terraso-allauth
```

Add the `terraso_allauth` app to the Django's `INSTALLED_APPS` along with proper `django-allauth` apps.

```python
INSTALLED_APPS = [
    # ...
    "allauth",
    "allauth.account",
    "allauth.socialaccount",
    "terraso_allauth",
    # ...
]
```

Add Terraso configuration to the `SOCIALACCOUNT_PROVIDERS` on settings:

```python
SOCIALACCOUNT_PROVIDERS = {
    ...
    'terraso': {
        'SCOPE': [
            'email',
            'openid',
            'profile',
        ],
    },
    ...
}
```

Optionally, you can set a `TERRASO_BASE_API_URL` to integrate with a Terraso instance differently from the default one. On your `settings.py`:

```python
TERRSO_BASE_API_URL = "https://your.terraso.org"
```

## Usage

The Terraso's URL for authorization, token exchange and profile information is automatically loaded by `django-allauth` following its default standards. If the installation processed described above was done correctly, you should now be able to start the OAuth authorization flow, accessing the proper Terraso authorization URL. For example:

```django
  <form action="{% url "terraso_login" %}" method="post">
    {% csrf_token %}
    <button type="submit">Login with Terraso</button>
  </form>
```

## Development

### Installing development dependencies

We highly recommend creating a local [virtualenv](https://docs.python.org/3/library/venv.html) for local development.

To have `terraso-allauth` set up locally for development, it's only a matter of installing a few development libraries. The following helper make action can help:

```sh
make install-dev
```

### Updating dependencies

All project dependencies are set in the requirements files located under the `requirements/` directory. The project is expected to run (and be tested) against different Django versions. That's the reason for similar requirement files.

If a dependency need to be added (or updated) __do not change any requirement*.txt file__. Instead, update the proper __requirement*.in__ file.

All `requirement*.txt` file are generated by `pip-tools`. To generate them, you can run the helper make actions below:

```sh
make lock
make lock-dev
```

### Running the tests

Before running tests, make sure you have the local `django-allauth` library installed in your `virtualenv`. It's recommended to installed it in edit mode:

```sh
pip install -e .
```

The tests can be run calling `pytest` on library directory (the same directory of this README file):

```sh
pytest
```

_Important: make sure you have the development dependencies installed. `make install-dev` can make the job._

### Running the tests across different environments

The project uses [tox](https://tox.wiki/en/latest/) to run the tests on all supported environments (different Python and Django versions). The current setup relies on [pyenv](https://github.com/pyenv/pyenv) to load different Python versions. So, make sure you have your environment ready for it.

To run `tox`, we recommend running it in parallel:

```sh
tox -p
```

### Building and releasing

Before building a new version to release, make sure a new git tag was created for the version. Then, run the following command to create a new build:

```sh
python -m build
```

Running the above command on the project directory, a new Python wheel will be created and properly versioned and named based on the git tags.

After a new wheel was created, make sure you have the `twine` Python lib installed: `pip install twine`. Then, run the following command to upload the recent created wheel to PyPI:

```sh
python -m twine upload --verbose dist/*
```

It will be necessary to inform the PyPI username and password to successfully upload the packages.

More information about packaging and distributing Python packages can be
found on [official documentation](https://packaging.python.org/en/latest/tutorials/packaging-projects/).
