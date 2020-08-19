//
//  ShellClient.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import Foundation

public class ShellClient: Shell {

    let currentPath: CurrentPath
    let logger: Logger

    public init(currentPath: CurrentPath,
                logger: Logger) {
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

    // MARK: - Input

    public func getInput(prompt: String?) throws -> String? {
        if let prompt = prompt {
            print(prompt, terminator: "")
        }

        return readLine(strippingNewline: true)
    }

    // MARK: - Execute

    @discardableResult
    public func execute(_ command: ShellCommand) throws -> String {
        return try shell(command.shellCommand)
    }

    // MARK: - Process

    @discardableResult
    func shell(_ command: String) throws -> String {
        logger.debug(command)

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
