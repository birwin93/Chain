//
//  PackageChain.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import ChainCore
import Foundation

public final class PackageChainGroup: ChainGroup {

    public static let name: String = "package"

    public static let chains: [Chain.Type] = [
        CreatePackageChain.self
    ]

    public init() {}
}
