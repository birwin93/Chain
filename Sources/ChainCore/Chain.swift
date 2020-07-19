//
//  Chain.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import ArgumentParser
import Foundation

public protocol Chain: ParsableCommand {

    static var name: String { get }
    static var description: String? { get }

    func run(context: Context) throws
}

extension Chain {

    public static var description: String? {
        return nil
    }

    public static var configuration: CommandConfiguration {
        return CommandConfiguration(
            commandName: name
        )
    }

    public func run() throws {
        let context = ChainContext()
        try run(context: context)
    }
}
