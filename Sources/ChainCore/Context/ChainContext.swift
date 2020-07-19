//
//  ChainContext.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import Foundation
import Logging

public class ChainContext: Context {

    var currentPath = CurrentPath()

    public let file: File
    public let logger: Logger
    public let shell: Shell

    public init() {

        let shell = ShellClient()
        shell.currentPath = currentPath

        self.file = FileClient(currentPath: currentPath)
        self.shell = shell
        
        self.logger = Logger(label: "com.chain.logger")
    }
}

/// CurrentPath keeps track of which directory the executable is currently running in
/// This is because using `context.shell.cd("some_folder")` opens up a new shell process
/// and won't persist for future commands. But by always referencing currentPath and updating it
/// accodringly, we can now run commands like:
/// ```
/// context.file.createDirectory("tests")
/// context.shell.cd("tests")
/// context.shell.createFile("TestFile.swift")
/// ```
public class CurrentPath {

    public var url: URL = URL(string: ".")!

    public var path: String {
        return url.path
    }

    public func cd(_ path: String) {
        if path.starts(with: "/") {
            url = URL(string: path)!
        } else {
            url = url.appendingPathComponent(path)
        }
    }
}
