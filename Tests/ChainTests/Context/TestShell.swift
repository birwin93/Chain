//
//  TestShell.swift
//  ChainTests
//
//  Created by Billy Irwin on 7/19/20.
//

import ChainCore
import Foundation

class TestShell: Shell {

    let testFile: TestFile

    private let currentPath: CurrentPath

    init(testFile: TestFile, currentPath: CurrentPath) {
        self.testFile = testFile
        self.currentPath = currentPath
    }

    func cd(_ path: String) throws {
        currentPath.cd(path)
    }

    func ls() throws {}

    func pwd() throws {
        print(currentPath.path)
    }

    func createSwiftPackage() throws {
        let packageName = currentPath.url.lastPathComponent
        try testFile.createFile(at: "Package.swift", contents: "")
        try testFile.createFile(at: "Sources/\(packageName)/main.swift", contents: "")
    }
}
