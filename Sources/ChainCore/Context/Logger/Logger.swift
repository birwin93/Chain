//
//  Logger.swift
//  ChainCore
//
//  Created by Billy Irwin on 7/19/20.
//

import Foundation
import Rainbow

public class Logger {

    private let isVerbose: Bool

    public init(isVerbose: Bool = false) {
        self.isVerbose = isVerbose
    }

    public func step(_ message: @autoclosure () -> String) {
        logToConsole(message().bold.underline + "\n")
    }

    /// Only prints is -v/--verbose is passed to command
    public func debug(_ message: @autoclosure () -> String) {
        if isVerbose {
            logToConsole(message())
        }
    }
    public func info(_ message: @autoclosure () -> String) {
        logToConsole(message())
    }

    public func error(_ message: @autoclosure () -> String) {
        logToConsole(message().red)
    }

    private func logToConsole(_ message: String) {
        // swiftlint:disable:next no_print
        print(message)
    }
}
