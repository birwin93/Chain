//
//  ChainError.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import Foundation

/// Error that's human readable
public protocol ChainError: Error, CustomStringConvertible {}

class GenericError: ChainError {
    
    let description: String
    
    init(_ description: String) {
        self.description = description
    }
}
