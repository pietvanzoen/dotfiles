.DEFAULT_GOAL := help
.PHONY: help lint update install bootstrap

help:
	@echo "make lint        Run shellcheck on all shell scripts"
	@echo "make update      Restow packages (symlinks)"
	@echo "make install     Install packages interactively"
	@echo "make bootstrap   Bootstrap a new machine"

lint: ## Run shellcheck on all shell scripts
ifdef FILES
	shellcheck $(FILES)
else
	@scripts=$$(find . \
		-not -path './.git/*' \
		-not -path '*/node_modules/*' \
		-not -path '*/_archive/*' \
		-not -path './shell/.local/bin/cht.sh' \
		-name '*.sh' -type f); \
	scripts="$$scripts $$(grep -rlE '^\#!.*(bash|sh)' \
		--include='*' \
		_scripts/ git/.local/bin/ shell/.local/bin/ shell/.local/lib/ macos/.local/bin/ \
		2>/dev/null | grep -v node_modules | grep -v '\.sh$$')"; \
	echo "==> Checking $$(echo $$scripts | wc -w | tr -d ' ') shell scripts..."; \
	shellcheck $$scripts
endif

update: ## Restow packages (symlinks)
	@_scripts/update

install: ## Install packages interactively
	@_scripts/install

bootstrap: ## Bootstrap a new machine
	@_scripts/bootstrap
