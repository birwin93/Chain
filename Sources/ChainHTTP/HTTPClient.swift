//
//  HTTPClient.swift
//  Chain
//
//  Created by Billy Irwin on 8/19/20.
//

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import Foundation

public class HTTPClient {

    public typealias NetworkResponse = (Data, HTTPURLResponse)

    private let host: String
    private var defaultHeaders: [String: String]
    private let session: URLSession

    private let requestModifier: ((inout URLRequest) -> Void)?

    /// Allows consumers to listen to network responses to handle potential
    /// side effects, like listening to 401/403s
    public var requestListener: ((Result<NetworkResponse, HTTPError>) -> Void)?

    public init(host: String,
                defaultHeaders: [String: String] = [:],
                requestModifier: ((inout URLRequest) -> Void)? = nil) {
        self.host = host
        self.defaultHeaders = defaultHeaders
        self.session = URLSession(configuration: .default)
        self.requestModifier = requestModifier
    }

    public func addDefaultHeader(key: String, value: String) {
        defaultHeaders[key] = value
    }

    public func get(_ path: String,
                    queryParams: [String: URLQueryParamConvertable] = [:],
                    headers: [String: String] = [:],
                    completion: ((Result<NetworkResponse, HTTPError>) -> Void)? = nil) {
        var request = URLRequest(url: url(path, queryParams: queryParams))
        request.allHTTPHeaderFields = defaultHeaders.merging(headers, uniquingKeysWith: { a, b in a })
        execute(request, completion: completion)
    }

    public func post(_ path: String,
                     headers: [String: String] = [:],
                     body: RequestBody? = nil,
                     completion: ((Result<NetworkResponse, HTTPError>) -> Void)? = nil) {
        do {
            var request = URLRequest(url: url(path))
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = defaultHeaders.merging(headers, uniquingKeysWith: { a, b in a })

            if let body = body {
                for (key, value) in body.headers {
                    request.allHTTPHeaderFields?[key] = value
                }
                request.httpBody = try body.encoded()

            }
            execute(request, completion: completion)
        } catch let error {
            completion?(.failure(.invalidBody(body, error.localizedDescription)))
        }
    }

    public func delete(_ path: String,
                       headers: [String: String] = [:],
                       body: RequestBody? = nil,
                       completion: ((Result<Void, HTTPError>) -> Void)? = nil) {
        do {
            var request = URLRequest(url: url(path))
            request.httpMethod = "DELETE"
            request.allHTTPHeaderFields = defaultHeaders.merging(headers, uniquingKeysWith: { a, b in a })

            if let body = body {
                for (key, value) in body.headers {
                    request.allHTTPHeaderFields?[key] = value
                }
                request.httpBody = try body.encoded()

            }
            execute(request) { result in
                switch result {
                case .success:
                    completion?(.success(Void()))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        } catch let error {
            completion?(.failure(.invalidBody(body, error.localizedDescription)))
        }
    }

    public func execute(_ request: URLRequest,
                        completion: ((Result<NetworkResponse, HTTPError>) -> Void)? = nil) {
        var request = request
        if let requestModifier = requestModifier {
            requestModifier(&request)
        }

        let task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion?(.failure(.noResponse(error?.localizedDescription)))
                return
            }

            if let error = error {
                completion?(.failure(.unknown(response.statusCode, error.localizedDescription)))
                return
            }

            guard let data = data else {
                completion?(.failure(.noData(response.statusCode)))
                return
            }

            let result: Result<NetworkResponse, HTTPError> = {
                switch response.statusCode {
                case 200..<300:
                    return .success((data, response))
                case 401:
                    return .failure(.unauthenticated(String(data: data, encoding: .utf8)))
                case 403:
                    return .failure(.unauthorized(String(data: data, encoding: .utf8)))
                case 404:
                    return .failure(.notFound(String(data: data, encoding: .utf8)))
                case 429:
                    return .failure(.rateLimited(String(data: data, encoding: .utf8)))
                default:
                    return .failure(.unknown(response.statusCode, String(data: data, encoding: .utf8)))
                }
            }()

            completion?(result)
            self?.requestListener?(result)
        })

        task.resume()
    }

    // MARK: - Typed Requests

    public func getJSON(_ path: String,
                        queryParams: [String: URLQueryParamConvertable] = [:],
                        headers: [String: String] = [:],
                        completion: ((Result<JSON, HTTPError>) -> Void)? = nil) {
        get(path, queryParams: queryParams, headers: headers) { result in
            switch result {
            case .success(let data, _):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .init()) as! JSON
                    completion?(.success(json))
                } catch let error {
                    completion?(.failure(.deserialization(data, error.localizedDescription)))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    public func postJSON(_ path: String,
                         headers: [String: String] = [:],
                         body: RequestBody? = nil,
                         completion: ((Result<JSON, HTTPError>) -> Void)? = nil) {
        post(path, headers: headers, body: body) { result in
            switch result {
            case .success(let data, _):
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .init()) as! JSON
                    completion?(.success(json))
                } catch let error {
                    completion?(.failure(.deserialization(data, error.localizedDescription)))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    public func get<T: Codable>(_ responseType: T.Type,
                                path: String,
                                queryParams: [String: URLQueryParamConvertable] = [:],
                                headers: [String: String] = [:],
                                completion: ((Result<T, HTTPError>) -> Void)? = nil) {
        get(path, queryParams: queryParams, headers: headers) { result in
            switch result {
            case .success(let data, _):
                do {
                    let object = try HTTPClient.decodeResponse(responseType, data: data)
                    completion?(.success(object))
                } catch let error {
                    print(error)
                    completion?(.failure(.deserialization(data, error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion?(.failure(error))
            }
        }
   }


    public func post<T: Codable>(_ responseType: T.Type,
                                 path: String,
                                 headers: [String: String] = [:],
                                 body: RequestBody? = nil,
                                 completion: @escaping (Result<T, HTTPError>) -> Void) {
        post(path, headers: headers, body: body) { result in
            switch result {
            case .success(let data, _):
                do {
                    let object = try HTTPClient.decodeResponse(responseType, data: data)
                    completion(.success(object))
                } catch let error {
                    print(error)
                    completion(.failure(.deserialization(data, error.localizedDescription)))
                }
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }

    private static func decodeResponse<T: Codable>(_ responseType: T.Type, data: Data) throws -> T {
        if responseType == String.self {
            return String(data: data, encoding: .utf8) as! T
        } else {
            let jsonDecoder = JSONDecoder()

            if let dateFormatterProvider = responseType as? DateFormatterProvider.Type {
                jsonDecoder.dateDecodingStrategy = .formatted(dateFormatterProvider.dateFormatter)
            }

            return try jsonDecoder.decode(T.self, from: data)
        }
    }

    // MARK: - Helpers

    private func url(_ path: String, queryParams: [String: URLQueryParamConvertable] = [:]) -> URL {
        let url = URL(string: "\(host)\(path)")!

        if queryParams.count == 0 {
            return url
        } else {
            return url.appendingQueryParameters(queryParams)
        }
    }
}

public protocol URLQueryParamConvertable {

    var stringValue: String { get }
}

extension String: URLQueryParamConvertable { public var stringValue: String { return self } }
extension Int: URLQueryParamConvertable { public var stringValue: String { return String(self) } }
extension Double: URLQueryParamConvertable { public var stringValue: String { return String(self) } }
extension Float: URLQueryParamConvertable { public var stringValue: String { return String(self) } }

extension Dictionary where Key == String, Value == URLQueryParamConvertable {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
    */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }

}

extension URL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new URL.
    */
    func appendingQueryParameters(_ parametersDictionary : [String: URLQueryParamConvertable]) -> URL {
        let URLString : String = String(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return URL(string: URLString)!
    }
}
