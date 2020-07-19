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
    
    let currentPath: CurrentPath

    var files: [String: String] = [:]

    init(currentPath: CurrentPath) {
        self.currentPath = currentPath
    }

    func fileExists(at path: String) -> Bool {
        return files[fullPath(path)] != nil
    }

    func fileContents(at path: String) throws -> String {
        return files[fullPath(path)] ?? ""
    }

    func createFile(at path: String, contents: String?) throws {
        files[fullPath(path)] = contents ?? ""
    }

    func write(_ contents: String, toFileAt path: String) throws {
        files[fullPath(path)] = contents
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
