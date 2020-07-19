//
//  TestFile.swift
//  ChainTests
//
//  Created by Billy Irwin on 7/18/20.
//

import ChainCore
import Foundation
import XCTest

class TestFile: File {

    var files: [String: String] = [:]

    init() {}

    func fileExists(at path: String) -> Bool {
        return files[path] != nil
    }

    func fileContents(at path: String) throws -> String {
        return files[path] ?? ""
    }

    func createFile(at path: String, contents: String?) throws {
        files[path] = contents ?? ""
    }

    func write(_ contents: String, toFileAt path: String) throws {
        files[path] = contents
    }

    func createDirectory(path: String) throws {
        // TODO figure this out
    }
}

// MARK: Assertion Helpers

extension TestFile {

    func assertContents(_ contents: String, at path: String, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(files[path], contents, file: file, line: line)
    }
}
