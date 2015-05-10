SHELL := /bin/bash

RUBY := ruby
NODE := node

SASS         := bundle exec sass
BROWSERIFY   := $(NODE) node_modules/.bin/browserify
EXORCIST     := $(NODE) node_modules/.bin/exorcist
UGLIFYJS     := $(NODE) node_modules/.bin/uglifyjs
AUTOPREFIXER := $(NODE) node_modules/.bin/autoprefixer

SOURCE := app/assets
BUILD  := assets

SASS_CMD := $(SASS) -rbourbon -Inode_modules -I$(SOURCE)
BROWSERIFY_CMD := $(BROWSERIFY) -i jquery -t coffeeify --extension=".coffee" -t browserify-data -t envify

REDMINE_VERSION := ${REDMINE_VERSION:-2.6.0}

SOURCE = app/assets
BUILD = assets

.PHONY: default
default: build

.PHONY: all
all: build min

.PHONY: js
js: $(BUILD)/main.js

.PHONY: css
css: fonts $(BUILD)/main.css

$(BUILD):
	mkdir -p $(BUILD)

.PHONY: fonts
fonts: $(BUILD)
	mkdir -p $(BUILD)/fonts
	cp node_modules/font-awesome/fonts/*-webfont* $(BUILD)/fonts

.PHONY: $(BUILD)/main.js
$(BUILD)/main.js: $(BUILD)
	NODE_PATH=.:$(SOURCE) NODE_ENV=development $(BROWSERIFY_CMD) --debug $(SOURCE)/main.coffee | $(EXORCIST) $(BUILD)/main.js.map > $(BUILD)/main.js

.PHONY: $(BUILD)/main.css
$(BUILD)/main.css: $(BUILD)
	$(SASS_CMD) --style nested $(SOURCE)/main.sass | $(AUTOPREFIXER) > $(BUILD)/main.css

.PHONY: $(BUILD)/main.min.js
$(BUILD)/main.min.js: $(BUILD)
	NODE_PATH=.:$(SOURCE) NODE_ENV=production $(BROWSERIFY_CMD) $(SOURCE)/main.coffee | $(UGLIFYJS) -m -c > $(BUILD)/main.min.js 2> /dev/null

.PHONY: $(BUILD)/main.min.css
$(BUILD)/main.min.css: $(BUILD)
	$(SASS_CMD) --style compressed $(SOURCE)/main.sass | $(AUTOPREFIXER) > $(BUILD)/main.min.css

.PHONY: build
build: fonts $(BUILD)/main.css $(BUILD)/main.js

.PHONY: min
min: fonts $(BUILD)/main.min.css $(BUILD)/main.min.js

.PHONY: clean
clean:
	rm -rf $(BUILD)/*

.PHONY: distclean
distclean:
	rm -rf node_modules
