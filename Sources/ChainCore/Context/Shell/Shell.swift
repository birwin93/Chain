//
//  Shell.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import Foundation

public protocol ShellCommand {
    var shellCommand: String { get }
}

public protocol Shell {

    // MARK: - Directory

    func cd(_ path: String) throws
    func ls() throws
    func pwd() throws

    // MARK: - Input

    func getInput(prompt: String?) throws -> String?

    // MARK: - Execute

    @discardableResult
    func execute(_ command: ShellCommand) throws -> String
}

// MARK: - Helpers

extension Shell {

    /// Asks a question that expects the user to answer either 'y' or 'n'
    ///   - Parameters:
    ///        - prompt: The question displayed to user
    ///   - Returns:
    ///         Either true ('y') or false ('n')
    public func getYesNoInput(prompt: String) throws -> Bool {
        var input = try getInput(prompt: prompt + " [y/n]: ")

        while input != "y" && input != "n" {
            input = try getInput(prompt: "Please respond either 'y' or 'n': ")
        }

        return input == "y"
    }
}
