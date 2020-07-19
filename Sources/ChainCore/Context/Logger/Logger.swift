//
//  Logger.swift
//  ChainCore
//
//  Created by Billy Irwin on 7/19/20.
//

import Foundation
import Rainbow

public class Logger {

    public init() {}

    public func step(_ message: @autoclosure () -> String) {
        logToConsole(message().bold.underline + "\n")
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
