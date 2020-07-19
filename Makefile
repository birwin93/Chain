ROOT = $(shell pwd)
PRODUCT_NAME = $(shell basename $(ROOT))
PROJECT_FILE = $(PRODUCT_NAME).xcodeproj

.PHONY: build clean

setup:
	brew list mint ||  brew install mint || true
	brew link mint
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