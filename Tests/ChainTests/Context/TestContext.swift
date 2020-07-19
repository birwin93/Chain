//
//  TestChain.swift
//  ChainTests
//
//  Created by Billy Irwin on 7/18/20.
//

import ChainCore
import Foundation
import Logging

class TestContext: Context {

    let currentPath = CurrentPath()

    let testFile: TestFile
    let testShell: TestShell

    init() {
        self.logger = Logger(label: "com.chain.test.logger")
        self.testFile = TestFile(currentPath: currentPath)
        self.testShell = TestShell(testFile: testFile, currentPath: currentPath, logger: logger)
    }

    // MARK: - Context

    var file: File {
        return testFile
    }

    var shell: Shell {
        return testShell
    }

    let logger: Logger
}
