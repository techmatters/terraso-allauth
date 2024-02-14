ifeq ($(DC_ENV),ci)
	UV_FLAGS = "--system"
endif

install:
	uv pip install -r requirements/requirements.txt $(UV_FLAGS)

install-dev:
	uv pip install -r requirements/requirements-dev.txt $(UV_FLAGS)

format:
	ruff format terraso_allauth

lint:
	ruff check terraso_allauth

setup-git-hooks:
	@pre-commit install

lock: pip-tools
	CUSTOM_COMPILE_COMMAND="make lock" uv pip compile --upgrade --output-file requirements/requirements.txt requirements/requirements.in
	CUSTOM_COMPILE_COMMAND="make lock" uv pip compile --upgrade --output-file requirements/requirements-dj2.txt requirements/requirements-dj2.in
	CUSTOM_COMPILE_COMMAND="make lock" uv pip compile --upgrade --output-file requirements/requirements-dj3.txt requirements/requirements-dj3.in
	CUSTOM_COMPILE_COMMAND="make lock" uv pip compile --upgrade --output-file requirements/requirements-dj4.txt requirements/requirements-dj4.in
	CUSTOM_COMPILE_COMMAND="make lock" uv pip compile --upgrade --output-file requirements/requirements-dj5.txt requirements/requirements-dj5.in

lock-dev: pip-tools
	CUSTOM_COMPILE_COMMAND="make lock-dev" uv pip compile --upgrade --output-file requirements/requirements-dev.txt requirements/requirements-dev.in

pip-tools: ${VIRTUAL_ENV}/scripts/pip-sync

test-ci:
	tox

${VIRTUAL_ENV}/scripts/pip-sync:
	uv pip install pip-tools
