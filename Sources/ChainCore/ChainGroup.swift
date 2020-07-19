//
//  ChainGroup.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import ArgumentParser
import Foundation

public protocol ChainGroup: Chain {

    static var chains: [Chain.Type] { get }
}

extension ChainGroup {

    public static var configuration: CommandConfiguration {
        return CommandConfiguration(
            commandName: name,
            abstract: description ?? "",
            subcommands: chains
        )
    }

     public func run(context: Context) throws {}
}
