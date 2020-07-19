//
//  TestChain.swift
//  ChainTests
//
//  Created by Billy Irwin on 7/18/20.
//

@testable import ChainCore
import Foundation

class TestContext: Context {
    
    let currentPath = CurrentPath()

    let testFile: TestFile
    let testShell: TestShell

    init() {
        self.testFile = TestFile(currentPath: currentPath)
        self.testShell = TestShell(testFile: testFile, currentPath: currentPath)
    }

    // MARK: - Context

    var file: File {
        return testFile
    }
    
    var shell: Shell {
        return testShell
    }
}
