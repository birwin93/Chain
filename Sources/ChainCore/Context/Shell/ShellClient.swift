//
//  ShellClient.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import Foundation

public class ShellClient: Shell {

    var currentPath: CurrentPath?

    public init() {}

    // MARK: - Directory

    public func cd(_ path: String) throws {
        try shell("cd \(path)")
        currentPath?.cd(path)
    }

    public func pwd() throws {
        print(try shell("pwd"))
    }

    public func ls() throws {
        print(try shell("ls"))
    }

    // MARK: - Swift

    public func createSwiftPackage() throws {
        try shell("swift package init")
    }

    // MARK: - Process

    @discardableResult
    func shell(_ command: String) throws -> String {
        print("Running command: \(command)")

        let pipe = Pipe()
        let errorPipe = Pipe()

        let task = Process()

        if let path = currentPath?.url.path {
            task.currentDirectoryPath = path
        }

        task.arguments = ["-c", command]
        task.launchPath = "/bin/bash"
        task.standardOutput = pipe
        task.standardError = errorPipe

        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let errorOutput = String(data: errorData, encoding: .utf8)

        task.waitUntilExit()

        switch task.terminationStatus {
        case 0:
            return output ?? ""
        default:
            throw GenericError(errorOutput ?? "Something went wrong")
        }
    }
}
