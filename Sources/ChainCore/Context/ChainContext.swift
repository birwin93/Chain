//
//  ChainContext.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import Foundation

public class ChainContext: Context {
    
    var currentPath = CurrentPath()

    public let file: File
    public let shell: Shell

    public init() {
        
        let url = URL(string: "http://blah.com")!
        print(url.path)
        
        let shell = ShellClient()
        shell.currentPath = currentPath
        
        self.file = FileClient(currentPath: currentPath)
        self.shell = shell
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
        
        print("Updated path to \(url.path)")
    }
}
