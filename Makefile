ifeq ($(DC_ENV),ci)
	UV_FLAGS = "--system"
endif

install:
	uv pip install -r requirements/requirements.txt $(UV_FLAGS)

install-dev:
	uv pip install -r requirements/requirements-dev-py313.txt $(UV_FLAGS)

format:
	ruff format terraso_allauth

lint:
	ruff check terraso_allauth

setup-git-hooks:
	@pre-commit install

lock:
	CUSTOM_COMPILE_COMMAND="make lock" uv pip compile --upgrade --output-file requirements/requirements.txt requirements/requirements.in
	CUSTOM_COMPILE_COMMAND="make lock" uv pip compile --upgrade --output-file requirements/requirements-dj2.txt requirements/requirements-dj2.in
	CUSTOM_COMPILE_COMMAND="make lock" uv pip compile --upgrade --output-file requirements/requirements-dj3.txt requirements/requirements-dj3.in
	CUSTOM_COMPILE_COMMAND="make lock" uv pip compile --upgrade --output-file requirements/requirements-dj4.txt requirements/requirements-dj4.in
	CUSTOM_COMPILE_COMMAND="make lock" uv pip compile --upgrade --output-file requirements/requirements-dj5.txt requirements/requirements-dj5.in

lock-dev:
	CUSTOM_COMPILE_COMMAND="make lock-dev" uv pip compile --upgrade --python-version 3.9 --output-file requirements/requirements-dev-py39.txt requirements/requirements-dev.in
	CUSTOM_COMPILE_COMMAND="make lock-dev" uv pip compile --upgrade --python-version 3.10 --output-file requirements/requirements-dev-py310.txt requirements/requirements-dev.in
	CUSTOM_COMPILE_COMMAND="make lock-dev" uv pip compile --upgrade --python-version 3.11 --output-file requirements/requirements-dev-py311.txt requirements/requirements-dev.in
	CUSTOM_COMPILE_COMMAND="make lock-dev" uv pip compile --upgrade --python-version 3.12 --output-file requirements/requirements-dev-py312.txt requirements/requirements-dev.in
	CUSTOM_COMPILE_COMMAND="make lock-dev" uv pip compile --upgrade --python-version 3.13 --output-file requirements/requirements-dev-py313.txt requirements/requirements-dev.in


${VIRTUAL_ENV}/scripts/ruff:
	uv pip install ruff
