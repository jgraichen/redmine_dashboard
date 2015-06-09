SHELL   := /bin/bash
NODE    := node
WEBPACK := $(NODE) node_modules/.bin/webpack

.PHONY: build
build:
	NODE_ENV=development $(WEBPACK)

.PHONY: watch
watch:
	NODE_ENV=development $(WEBPACK) --watch

.PHONY: production
production:
	NODE_ENV=production $(WEBPACK)

.PHONY: clean
clean:
	rm -r assets/*

.PHONY: distclean
distclean:
	rm -r node_modules
