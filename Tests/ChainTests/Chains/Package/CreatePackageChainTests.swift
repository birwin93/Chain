//
//  CreatePackageChainTests.swift
//  ChainTests
//
//  Created by Billy Irwin on 7/18/20.
//

import ChainCore
import Chains
import Foundation
import XCTest

class CreatePackageChainTests: XCTestCase {

    var chain: CreatePackageChain!
    var context: TestContext!

    override func setUp() {
        chain = CreatePackageChain()
        context = TestContext()
    }

    func testChain() {
        context.testShell.mockUserInput("y") // Makefile
        context.testShell.mockUserInput("y") // Swiftlint

        chain.name = "test-package"
        chain.testRun(context: context)
        context.testFile.assertContents("", at: "./test-package/Package.swift")
        context.testFile.assertContents("", at: "./test-package/Sources/test-package/main.swift")
        context.testFile.assertContents("realm/swiftlint@0.39.2", at: "./test-package/Mintfile")
    }
}
