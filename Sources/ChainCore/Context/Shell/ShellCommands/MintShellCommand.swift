//
//  MintShellCommand.swift
//  ChainCore
//
//  Created by Billy Irwin on 8/19/20.
//

import Foundation

public enum MintShellCommand: ShellCommand {

    /// Downloads all Mint dependencies
    case bootstrap

    public var shellCommand: String {
        switch self {
        case .bootstrap:
            return "mint bootstrap"
        }
    }
}
