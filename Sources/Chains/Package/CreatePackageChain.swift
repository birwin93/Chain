//
//  CreatePackageChain.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import ArgumentParser
import ChainCore
import Foundation

public final class CreatePackageChain: Chain {

    @Argument()
    public var name: String

    public static let name: String = "create"

    public init() {}

    public func run(context: Context) throws {
        context.logger.step("Creating new swift package for \(name)")
        try context.file.createDirectory(path: name)
        try context.shell.cd(name)
        try context.shell.createSwiftPackage()
        try createMakefile(with: context)
        try createMintFile(with: context)
    }

    private func createMakefile(with context: Context) throws {
        context.logger.step("Generating Makefile")

        let makefile = """
        ROOT = $(shell pwd)
        PRODUCT_NAME = $(shell basename $(ROOT))
        PROJECT_FILE = $(PRODUCT_NAME).xcodeproj

        .PHONY: build clean

        bootstrap:
            brew list mint ||  brew install mint || true
            brew link mint

            brew list danger/tap/danger-swift ||  brew install danger/tap/danger-swift || true
            brew link danger/tap/danger-swift

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
            open $(PROJECT_FILE)%
        """

        try context.file.createFile(
            at: "Makefile",
            contents: makefile
        )
    }

    private func createMintFile(with context: Context) throws {
        context.logger.step("Generating Mintfile and installing common dependencies")

        try context.file.createFile(
            at: "Mintfile",
            contents: """
            realm/swiftlint@0.39.2
            """
        )

        try context.shell.mintBootstrap()
    }
}
