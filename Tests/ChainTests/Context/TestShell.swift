//
//  TestShell.swift
//  ChainTests
//
//  Created by Billy Irwin on 7/19/20.
//

import ChainCore
import Foundation
import Logging

class TestShell: Shell {

    let testFile: TestFile
    let logger: Logger

    private let currentPath: CurrentPath

    init(testFile: TestFile, currentPath: CurrentPath, logger: Logger) {
        self.testFile = testFile
        self.currentPath = currentPath
        self.logger = logger
    }

    func cd(_ path: String) throws {
        currentPath.cd(path)
    }

    func ls() throws {}

    func pwd() throws {
        logger.info("\(currentPath.path)")
    }

    func createSwiftPackage() throws {
        let packageName = currentPath.url.lastPathComponent
        try testFile.createFile(at: "Package.swift", contents: "")
        try testFile.createFile(at: "Sources/\(packageName)/main.swift", contents: "")
    }

    func mintBootstrap() throws {}
}
