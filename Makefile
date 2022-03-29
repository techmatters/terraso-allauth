install:
	pip install -r requirements.txt

install-dev:
	pip install -r requirements-dev.txt

lock: pip-tools
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements.txt requirements/requirements.in
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements-dj2.txt requirements/requirements-dj2.in
	CUSTOM_COMPILE_COMMAND="make lock" pip-compile --upgrade --output-file requirements/requirements-dj3.txt requirements/requirements-dj3.in

lock-dev: pip-tools
	CUSTOM_COMPILE_COMMAND="make lock-dev" pip-compile --upgrade --output-file requirements/requirements-dev.txt requirements/requirements-dev.in

pip-tools: ${VIRTUAL_ENV}/scripts/pip-sync

${VIRTUAL_ENV}/scripts/pip-sync:
	pip install pip-tools
