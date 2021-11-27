PYTHONPATH := .
VENV := venv
PYMODULE := themis

MAIN_FILE := main.py
REQUIREMENTS_FILE := -r requirements.txt
ISORT_CFG_FILE := .isort.cfg

DATA_OUT_DIR := data/out/

BIN := $(VENV)/bin
PIP := $(BIN)/pip
PYLINT := $(BIN)/pylint
BLACK := $(BIN)/black
ISORT := $(BIN)/isort
PRE_COMMIT := $(BIN)/pre-commit

PYTHON := env PYTHONPATH=$(PYTHONPATH) $(BIN)/python

.PHONY: run
run:
	$(PYTHON) $(MAIN_FILE)

.PHONY: bootstrap
bootstrap: venv \
	requirements \
	pre-commit-hooks

.PHONY: venv
venv:
	python3 -m venv $(VENV)

.PHONY: requirements
requirements:
	$(PIP) install $(REQUIREMENTS_FILE)

.PHONY: pre-commit-hooks
pre-commit-hooks:
	$(PRE_COMMIT) install

.PHONY: lint
lint:
	$(PYLINT) --verbose $(PYMODULE) $(MAIN_FILE)

.PHONY: format-isort
format-isort:
	$(ISORT) $(PYMODULE) $(MAIN_FILE)

.PHONY: format-black
format-black:
	$(BLACK) --settings-path=$(ISORT_CFG_FILE) $(PYMODULE) $(MAIN_FILE)

.PHONY: format-all
format-all: format-isort \
	format-black

.PHONY: clean
clean:
	@find . -type d -name '__pycache__' -exec rm -rf {} +
	@find . -type d -name '*pytest_cache*' -exec rm -rf {} +
	@find . -type d -name 'htmlcov' -exec rm -rf {} +
	@find . -type f -name '*.coverage' -exec rm -rf {} +
	@find . -type f -name '*.py[co]' -exec rm -rf {} +
	@find . -type f -name '*.log' -exec rm -rf {} +

.PHONY: clean-data
clean-data:
	@find $(DATA_OUT_DIR) -type f -wholename '*.txt' -exec rm -rf {} +
	@find $(DATA_OUT_DIR) -type f -wholename '*.csv' -exec rm -rf {} +

.PHONY: clean-all
clean-all: clean \
	clean-data
	@rm -r $(VENV)
