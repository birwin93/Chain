//
//  ChainContext.swift
//  Chain
//
//  Created by Billy Irwin on 7/18/20.
//

import Foundation

public class ChainContext: Context {

    public let file: File

    public init(file: File = FileClient()) {
        self.file = file
    }
}
