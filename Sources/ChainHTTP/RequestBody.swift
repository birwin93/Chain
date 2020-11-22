//
//  RequestBody.swift
//  ChainHTTP
//
//  Created by Billy Irwin on 8/19/20.
//

import Foundation

public struct EncodableContainer: Encodable {

    let encodeBlock: (inout UnkeyedEncodingContainer) throws -> Void

    init<T: Encodable>(_ data: T) {
        self.encodeBlock = { container in
            try container.encode(data)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try encodeBlock(&container)
    }
}

public enum RequestBody {
    case data(Data, contentType: String)
    case json([String: Any])
    case jsonEncodable(EncodableContainer)
    case urlEncoded([String: Any])

    static func jsonEncodable<T: Encodable>(_ data: T) -> RequestBody {
        return RequestBody.jsonEncodable(EncodableContainer(data))
    }

    public var headers: [String: String] {
        switch self {
        case .data(_, let contentType):
            return ["Content-Type": contentType]
        case .json,
             .jsonEncodable:
            return ["Content-Type": "application/json"]
        case .urlEncoded:
            return ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
        }
    }

    public func encoded() throws -> Data {
        switch self {
        case .data(let data, _):
            return data
        case .json(let json):
            return try JSONSerialization.data(withJSONObject: json, options: .init())
        case .jsonEncodable(let encodable):
            return try JSONEncoder().encode(encodable)
        case .urlEncoded(let json):
            let formattedString = json.map { "\($0)=\($1)" }.joined(separator: "&")
            guard let data = formattedString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.data(using: .utf8) else {
                throw RequestBodyError("Can't serialize data to url encoded")
            }
            return data
        }
    }
}

public struct RequestBodyError: Error, CustomStringConvertible {
    public let description: String

    public init(_ description: String) {
        self.description = description
    }
}

