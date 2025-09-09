install:
	pip install -r requirements/requirements.txt

install-dev:
	pip install -r requirements/requirements-dev.txt

format:
	isort --atomic terraso_allauth
	black terraso_allauth

lint:
	flake8 terraso_allauth tests && isort -c terraso_allauth tests

lock: pip-tools
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements.txt requirements/requirements.in

lock-dev: pip-tools
	CUSTOM_COMPILE_COMMAND="make lock-dev" pip-compile --upgrade --output-file requirements/requirements-dev.txt requirements/requirements-dev.in

pip-tools: ${VIRTUAL_ENV}/scripts/pip-sync

test-ci:
	tox

${VIRTUAL_ENV}/scripts/pip-sync:
	pip install pip-tools
