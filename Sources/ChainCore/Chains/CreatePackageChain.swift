//
//  CreatePackageChain.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import ArgumentParser
import Foundation

public final class CreatePackageChain: Chain {

    @Argument()
    public var name: String

    public static let name: String = "create"

    public func run(context: Context) throws {
        try context.file.createDirectory(path: name)
        try context.shell.cd(name)
        try context.shell.createSwiftPackage()
        try context.file.createFile(at: "Blah.swift", contents: "wow")
    }

    public init() {}
}
