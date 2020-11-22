//
//  File+Codable.swift
//  ChainCore
//
//  Created by Billy Irwin on 11/22/20.
//

import Foundation

extension File {

    public func readJSONDecodable<T: Decodable>(_ type: T.Type,
                                                from path: String,
                                                using decoder: JSONDecoder = JSONDecoder()) throws -> T {
        let contents = try fileContents(at: path)
        let data = contents.data(using: .utf8)!
        return try decoder.decode(T.self, from: data)
    }

    public func writeJSONEncodable<T: Encodable>(_ encodable: T,
                                                 to path: String,
                                                 using encoder: JSONEncoder = JSONEncoder()) throws {
        let data = try encoder.encode(encodable)
        let dataString = String(data: data, encoding: .utf8)!
        try write(dataString, toFileAt: path)
    }
}
