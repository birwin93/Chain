ROOT = $(shell pwd)
PRODUCT_NAME = $(shell basename $(ROOT))
PROJECT_FILE = $(PRODUCT_NAME).xcodeproj

define brew_install
	echo "CALLED"
	echo $(1)
    brew list $(1) ||  brew install $(1) || true
	brew link $(1)
endef

.PHONY: build clean

setup:
	brew list mint ||  brew install mint || true
	brew link mint

	brew list danger/tap/danger-swift ||  brew install danger/tap/danger-swift || true
	brew link danger/tap/danger-swift

	mint bootstrap

build:
	swift build

release: clean
	swift build --disable-sandbox -c release

install:
	cp .build/release/OddsTracker /usr/bin/odds-tracker

clean:
	rm -rf $(PROJECT_FILE)
	rm -rf .build

test:
	swift test

xcode:
	swift package generate-xcodeproj
	open $(PROJECT_FILE)