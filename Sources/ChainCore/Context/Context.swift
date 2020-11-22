//
//  Context.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import Foundation

public protocol Context {
    var env: Env { get }
    var file: File { get }
    var shell: Shell { get }
    var logger: Logger { get }
}
