CI := $(if $(CI),yes,no)
SHELL := /bin/bash

ifeq ($(CI), yes)
	POETRY_OPTS = --ansi -v
	PRE_COMMIT_OPTS = --show-diff-on-failure --verbose
endif

help: ## show this message
	@awk \
		'BEGIN {FS = ":.*##"; printf "\nUsage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
		$(MAKEFILE_LIST)

fix: run-pre-commit ## run all automatic fixes

fix-md: ## automatically fix markdown files
	@poetry run pre-commit run mdformat --all-files

lint: ## run all linters
	@if [ $${CI} ]; then \
		echo ""; \
		echo "skipped linters that have dedicated jobs"; \
	else \
		echo ""; \
		$(MAKE) --no-print-directory lint-shellcheck; \
	fi

# cspell:ignore EPEL
lint-shellcheck: ## lint shell scripts using shellcheck
	@echo "Running shellcheck..."
	@if [ -z "$(command -v shellcheck)" ]; then \
		find ./scripts -name "*.sh" -type f -print0 | xargs -0r shellcheck; \
	else \
		echo "shellcheck not installed - install it to lint bash scripts"; \
		echo "  - Debian: apt install shellcheck"; \
		echo "  - EPEL: yum -y install epel-release && yum install ShellCheck"; \
		echo "  - macOS: brew install shellcheck"; \
	fi;
	@echo ""

run-pre-commit: ## run pre-commit for all files
	@poetry run pre-commit run $(PRE_COMMIT_OPTS) \
		--all-files \
		--color always

setup: setup.poetry setup.pre-commit setup-npm ## setup local dev environment

setup-npm: ## install node dependencies
	@npm ci

setup.poetry: ## setup python virtual environment
	@poetry sync $(POETRY_OPTS)

setup.pre-commit: ## install pre-commit git hooks
	@poetry run pre-commit install

spellcheck: ## run cspell
	@echo "Running cSpell to checking spelling..."
	@npm exec --no -- cspell lint . \
		--color \
		--config .vscode/cspell.json \
		--dot \
		--gitignore \
		--must-find-files \
		--no-progress \
		--relative \
		--show-context
