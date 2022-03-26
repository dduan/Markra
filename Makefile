SHELL = /bin/bash

BIN_DIR=tmp/bin
XCODEGEN_VERSION=2.27.0
XCODEGEN=$(BIN_DIR)/xcodegen-$(XCODEGEN_VERSION)
XCODEGEN_ARCHIVE=tmp/xcodegen-$(XCODEGEN_VERSION).zip

.PHONY: generate
generate: $(XCODEGEN)
	@$(XCODEGEN)

.PHONY: test
test: generate
	@xcodebuild test -scheme Markra

$(XCODEGEN): $(XCODEGEN_ARCHIVE)
	@mkdir -p $(BIN_DIR)
	@rm -rf tmp/xcodegen
	@unzip $(XCODEGEN_ARCHIVE) -d tmp
	@PREFIX=tmp tmp/xcodegen/install.sh
	@mv $(BIN_DIR)/xcodegen $@

$(XCODEGEN_ARCHIVE):
	@mkdir -p $(BIN_DIR)
	@wget https://github.com/yonaskolb/XcodeGen/releases/download/$(XCODEGEN_VERSION)/xcodegen.zip -O $@

.PHONY: clean
clean:
	@rm -rf tmp
