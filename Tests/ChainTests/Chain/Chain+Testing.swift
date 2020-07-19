//
//  Chain+Testing.swift
//  ChainTests
//
//  Created by Billy Irwin on 7/18/20.
//

import ChainCore
import Foundation
import XCTest

extension Chain {
    
    func testRun(context: Context, file: StaticString = #file, line: UInt = #line) {
        do {
            try run(context: context)
        } catch {
            XCTFail("\(error)", file: file, line: line)
        }
    }
}
