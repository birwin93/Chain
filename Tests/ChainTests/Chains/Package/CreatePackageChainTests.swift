//
//  CreatePackageChainTests.swift
//  ChainTests
//
//  Created by Billy Irwin on 7/18/20.
//

import ChainCore
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
        chain.name = "test-package"
        chain.testRun(context: context)
        context.testFile.assertContents("bla", at: "test-package/TestFile.swift")
    }
}
