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
        
        let shell = ShellClient()
        shell.currentPath = currentPath
        
        self.file = FileClient(currentPath: currentPath)
        self.shell = shell
    }
}

public class CurrentPath {
    
    var url: URL = URL(string: ".")!
    
    func cd(_ path: String) {
        if path.starts(with: "/") {
            url = URL(string: path)!
        } else {
            url = url.appendingPathComponent(path)
        }
        
        print("Updated path to \(url.path)")
    }
}
