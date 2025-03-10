install:
	pip install -r requirements/requirements.txt

install-dev:
	pip install -r requirements/requirements-dev.txt

format:
	ruff format terraso_allauth

lint:
	ruff check terraso_allauth

setup-git-hooks:
	@pre-commit install

lock: pip-tools
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements.txt requirements/requirements.in
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements-dj2.txt requirements/requirements-dj2.in
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements-dj3.txt requirements/requirements-dj3.in

lock-dev: pip-tools
	CUSTOM_COMPILE_COMMAND="make lock-dev" pip-compile --upgrade --output-file requirements/requirements-dev.txt requirements/requirements-dev.in

pip-tools: ${VIRTUAL_ENV}/scripts/pip-sync

test-ci:
	tox

${VIRTUAL_ENV}/scripts/pip-sync:
	pip install pip-tools
