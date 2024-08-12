install:
	pip install -r requirements/requirements.txt

install-dev:
	pip install -r requirements/requirements-dev.txt

lint:
	flake8 terraso_allauth tests && isort -c terraso_allauth tests

format: ${VIRTUAL_ENV}/scripts/black ${VIRTUAL_ENV}/scripts/isort
	isort --atomic terraso_allauth tests
	black terraso_allauth tests

lock: pip-tools
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements.txt requirements/requirements.in
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements-dj2.txt requirements/requirements-dj2.in
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements-dj3.txt requirements/requirements-dj3.in
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements-dj4.txt requirements/requirements-dj4.in
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements-dj5.txt requirements/requirements-dj5.in

lock-dev: pip-tools
	CUSTOM_COMPILE_COMMAND="make lock-dev" pip-compile --upgrade --output-file requirements/requirements-dev.txt requirements/requirements-dev.in

pip-tools: ${VIRTUAL_ENV}/scripts/pip-sync

test-ci:
	tox

${VIRTUAL_ENV}/scripts/black:
	pip install black

${VIRTUAL_ENV}/scripts/isort:
	pip install isort

${VIRTUAL_ENV}/scripts/pip-sync:
	pip install pip-tools
