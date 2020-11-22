//
//  HTTPError.swift
//  ChainHTTP
//
//  Created by Billy Irwin on 8/19/20.
//

import Foundation

public enum HTTPError: Error, CustomStringConvertible {

    case noData(Int)
    case noResponse(String?)
    case badRequest(String?)      // 400
    case unauthenticated(String?) // 401
    case unauthorized(String?)    // 403
    case notFound(String?)        // 404
    case rateLimited(String?)     // 429
    case unknown(Int, String?)    // 500

    // MARK: - Deserialization

    case deserialization(Data, String?)
    case keyNotFound(String)

    // MARK: - Encoding

    case invalidBody(RequestBody?, String?)

    public var description: String {
        switch self {
        case .noData(let code):
            return "No response data with response code: \(code)"
        case .badRequest(let description):
            return "Bad Request: \(description ?? "")"
        case .unauthenticated(let description):
            return "Unauthenticated: \(description ?? "")"
        case .unauthorized(let description):
            return "Unauthorized: \(description ?? "")"
        case .notFound(let description):
            return "Not Found: \(description ?? "")"
        case .rateLimited(let description):
            return "Rate Limited: \(description ?? "")"
        case .unknown(let code, let description):
            return "Error \(code) \(description ?? "")"
        case .deserialization(_, let description):
            return "Deserialization: \(description ?? "")"
        case .keyNotFound(let key):
            return "Deserialization: Key not found: \(key)"
        case .noResponse(_):
            return "No response"
        case .invalidBody(let body, let description):
            return "Could not encode body \(body): \(description ?? "")"
        }
    }
}
