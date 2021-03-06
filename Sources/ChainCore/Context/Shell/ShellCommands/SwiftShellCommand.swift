//
//  SwiftShellCommand.swift
//  ChainCore
//
//  Created by Billy Irwin on 8/19/20.
//

import Foundation

public enum SwiftShellCommand: ShellCommand {

    /// Initializes a swift package in the current directory
    case initPackage
    case generateXcode

    public var shellCommand: String {
        switch self {
        case .initPackage:
            return "swift package init"
        case .generateXcode:
            return "swift package generate-xcode"
        }
    }
}
