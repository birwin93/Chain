//
//  XcodeChain.swift
//  Chains
//
//  Created by Billy Irwin on 8/19/20.
//

import ArgumentParser
import ChainCore
import Foundation

public final class XcodeChain: Chain {

    public static let name: String = "xcode"

    public init() {}

    public func run(context: Context) throws {
        try context.shell.execute(SwiftShellCommand.generateXcode)
    }
}
