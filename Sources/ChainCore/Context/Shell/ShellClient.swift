//
//  ShellClient.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import Foundation
import Logging

public class ShellClient: Shell {

    let currentPath: CurrentPath
    let logger: Logger

    public init(currentPath: CurrentPath, logger: Logger) {
        self.currentPath = currentPath
        self.logger = logger
    }

    // MARK: - Directory

    public func cd(_ path: String) throws {
        try shell("cd \(path)")
        currentPath.cd(path)
    }

    public func pwd() throws {
        let output = try shell("pwd")
        logger.info("\(output)")
    }

    public func ls() throws {
        let output = try shell("ls")
        logger.info("\(output)")
    }

    // MARK: - Swift

    public func createSwiftPackage() throws {
        let output = try shell("swift package init")
        logger.info("\(output)")
    }

    // MARK: - Mint

    public func mintBootstrap() throws {
        let output = try shell("mint bootstrap")
        logger.info("\(output)")
    }

    // MARK: - Process

    @discardableResult
    func shell(_ command: String) throws -> String {
        let pipe = Pipe()
        let errorPipe = Pipe()

        let task = Process()

        task.currentDirectoryPath = currentPath.url.path

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
