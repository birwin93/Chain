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
        context.testFile.assertContents("", at: "./test-package/Package.swift")
        context.testFile.assertContents("", at: "./test-package/Sources/test-package/main.swift")
        context.testFile.assertContents("wow", at: "./test-package/Blah.swift")
    }
}
