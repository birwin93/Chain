//
//  TestChain.swift
//  ChainTests
//
//  Created by Billy Irwin on 7/18/20.
//

@testable import ChainCore
import Foundation

class TestContext: Context {

    let testFile: TestFile

    init(testFile: TestFile = TestFile()) {
        self.testFile = testFile
    }

    // MARK: - Context

    var file: File {
        return testFile
    }
}
