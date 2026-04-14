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
		-not -path './.claude/*' \
		-not -path './shell/.tmux/*' \
		-not -path './shell/.local/bin/cht.sh' \
		-not -path './shell/.local/lib/git-prompt.sh' \
		-not -path './shell/.local/bin/imgcat' \
		-not -path './shell/.local/bin/imgls' \
		-not -path './shell/.local/bin/it2attention' \
		-not -path './shell/.local/bin/it2check' \
		-not -path './shell/.local/bin/it2copy' \
		-not -path './shell/.local/bin/it2dl' \
		-not -path './shell/.local/bin/it2getvar' \
		-not -path './shell/.local/bin/it2setkeylabel' \
		-not -path './shell/.local/bin/it2ul' \
		-not -path './shell/.local/bin/it2universion' \
		-name '*.sh' -type f); \
	scripts="$$scripts $$(grep -rlE '^\#!.*(bash|sh)' \
		--include='*' \
		_scripts/ git/.local/bin/ shell/.local/bin/ shell/.local/lib/ macos/.local/bin/ \
		2>/dev/null | grep -v node_modules | grep -v '\.sh$$' \
		| grep -v 'shell/.local/bin/imgcat$$' \
		| grep -v 'shell/.local/bin/imgls$$' \
		| grep -v 'shell/.local/bin/it2')"; \
	echo "==> Checking $$(echo $$scripts | wc -w | tr -d ' ') shell scripts..."; \
	shellcheck $$scripts && echo "==> All shell scripts passed linting!"
endif

update: ## Restow packages (symlinks)
	@_scripts/update

install: ## Install packages interactively
	@_scripts/install

bootstrap: ## Bootstrap a new machine
	@_scripts/bootstrap
