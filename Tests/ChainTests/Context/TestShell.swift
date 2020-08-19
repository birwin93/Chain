//
//  TestShell.swift
//  ChainTests
//
//  Created by Billy Irwin on 7/19/20.
//

import ChainCore
import Foundation

class TestShell: Shell {

    let testFile: TestFile
    let logger: Logger

    private let currentPath: CurrentPath

    private var mockExecutables: [String: (TestShell) throws -> String] = [:]
    private var mockUserInputs: [String] = []

    init(testFile: TestFile, currentPath: CurrentPath, logger: Logger) {
        self.testFile = testFile
        self.currentPath = currentPath
        self.logger = logger

        mockDefaults()
    }

    func cd(_ path: String) throws {
        currentPath.cd(path)
    }

    func ls() throws {}

    func pwd() throws {
        logger.info("\(currentPath.path)")
    }

    func getInput(prompt: String?) throws -> String? {
        guard let input = mockUserInputs.first else {
            throw TestShellError.noUserInput
        }

        mockUserInputs.removeFirst()
        return input
    }

    func execute(_ command: ShellCommand) throws -> String {
        guard let executable = mockExecutables[command.shellCommand] else {
            throw TestShellError.commandNotMocked(command)
        }

        return try executable(self)
    }

    // MARK: - Mocking

    func mockCommand(_ command: ShellCommand, executable: @escaping (TestShell) throws -> String) {
        mockExecutables[command.shellCommand] = executable
    }

    func mockUserInput(_ input: String) {
        mockUserInputs.append(input)
    }

    func createSwiftPackage() throws {
        let packageName = currentPath.url.lastPathComponent
        try testFile.createFile(at: "Package.swift", contents: "")
        try testFile.createFile(at: "Sources/\(packageName)/main.swift", contents: "")
    }

    func mintBootstrap() throws {}
}

// MARK: - TestShellError

enum TestShellError: Error {
    case commandNotMocked(ShellCommand)
    case noUserInput
}

// MARK: - Default Mocking

extension TestShell {

    func mockDefaults() {
        mockSwiftCommands()
        mockMintCommands()
    }

    private func mockSwiftCommands() {
        mockCommand(SwiftShellCommand.initPackage, executable: { shell in
            let packageName = shell.currentPath.url.lastPathComponent
            try shell.testFile.createFile(at: "Package.swift", contents: "")
            try shell.testFile.createFile(at: "Sources/\(packageName)/main.swift", contents: "")
            return ""
        })
    }

    private func mockMintCommands() {
        mockCommand(MintShellCommand.bootstrap, executable: { _ in return "" })
    }
}
