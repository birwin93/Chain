import XCTest

import shipTests

var tests = [XCTestCaseEntry]()
tests += shipTests.allTests()
XCTMain(tests)
