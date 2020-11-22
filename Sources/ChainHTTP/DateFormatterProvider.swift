//
//  DateFormatterProvider.swift
//  ChainHTTP
//
//  Created by Billy Irwin on 11/22/20.
//

import Foundation

public protocol DateFormatterProvider {
    static var dateFormatter: DateFormatter { get }
}
