ROOT = $(shell pwd)
PRODUCT_NAME = $(shell basename $(ROOT))
PROJECT_FILE = $(PRODUCT_NAME).xcodeproj

define brew_install
    brew list $(1) ||  brew install $(1) || true
	brew link $(1)
endef

.PHONY: build clean

setup:
	$(call brew_install mint)
	$(call brew_install danger-swift)
	mint bootstrap

build:
	swift build

clean:
	rm -rf $(PROJECT_FILE)
	rm -rf .build

test:
	swift test

xcode:
	swift package generate-xcodeproj
	open $(PROJECT_FILE)