//
//  Shell.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import Foundation

public protocol Shell {
    
    // MARK: - Direcatory
    
    func cd(_ path: String) throws
    func ls() throws
    func pwd() throws
    
    // MARK: - Swift
    
    func createSwiftPackage() throws
}
