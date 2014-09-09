RUBY = ruby
NODE = node
SASS = $(RUBY) -S sass -rbourbon -Ibower_components -Inode_modules -I$(SOURCE)
BROWSERIFY = browserify -i jquery -t coffeeify --extension=".coffee" -t browserify-data -t envify
EXORCIST = exorcist
UGLIFYJS = uglifyjs
NODE_PATH = .:app/assets:bower_components
PATH := node_modules/.bin:${PATH}

SOURCE = app/assets
BUILD = assets

.PHONY: default
default: build

.PHONY: all
all: default

.PHONY: js
js: $(BUILD)/main.js

.PHONY: css
css: fonts $(BUILD)/main.css

$(BUILD):
	mkdir -p $(BUILD)

.PHONY: fonts
fonts: $(BUILD)
	mkdir -p $(BUILD)/fonts
	cp bower_components/font-awesome/fonts/*-webfont* $(BUILD)/fonts

.PHONY: $(BUILD)/main.js
$(BUILD)/main.js: $(BUILD)
	NODE_PATH=$(NODE_PATH) NODE_ENV=development $(BROWSERIFY) --debug $(SOURCE)/main.coffee | $(EXORCIST) $(BUILD)/main.js.map > $(BUILD)/main.js

.PHONY: $(BUILD)/main.css
$(BUILD)/main.css: $(BUILD)
	$(SASS) --style nested $(SOURCE)/main.sass $(BUILD)/main.css

.PHONY: $(BUILD)/main.min.js
$(BUILD)/main.min.js: $(BUILD)
	NODE_PATH=$(NODE_PATH) NODE_ENV=production $(BROWSERIFY) $(SOURCE)/main.coffee | $(UGLIFYJS) -m -c > $(BUILD)/main.min.js 2> /dev/null

.PHONY: $(BUILD)/main.min.css
$(BUILD)/main.min.css: $(BUILD)
	$(SASS) --style compressed $(SOURCE)/main.sass $(BUILD)/main.min.css

.PHONY: build
build: fonts $(BUILD)/main.css $(BUILD)/main.js

.PHONY: min
min: fonts $(BUILD)/main.min.js $(BUILD)/main.min.css

.PHONY: watch
watch:
	$(NODE) node_modules/.bin/nodemon --exec "make all" --watch $(SOURCE) -e js,coffee,sass

.PHONY: install-deps
install-deps:
	npm install
	bower install

.PHONY: clean
clean:
	rm -rf $(BUILD)/*

.PHONY: clean-deps
clean-deps:
	rm -rf node_modules bower_components
