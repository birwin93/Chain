//
//  File.swift
//  ship
//
//  Created by Billy Irwin on 7/18/20.
//

import Foundation

public protocol File {
    
    var currentPath: CurrentPath { get }
    
    // MARK: - File Management

    func fileExists(at path: String) -> Bool

    func fileContents(at path: String) throws -> String

    func createFile(at path: String, contents: String?) throws

    func write(_ contents: String, toFileAt path: String) throws

    // MARK: - Directory Management

    func createDirectory(path: String) throws
}

// MARK: - Helpers

extension File {
    
    public func fullPath(_ path: String) -> String {
        return currentPath.url.appendingPathComponent(path).path
    }
}

// MARK: - FileClient

public class FileClient: File {
    
    private let fileManager: FileManager
    public let currentPath: CurrentPath

    public init(fileManager: FileManager = .default,
                currentPath: CurrentPath) {
        self.fileManager = fileManager
        self.currentPath = currentPath
    }

    public func fileExists(at path: String) -> Bool {
        return fileManager.fileExists(atPath: fullPath(path))
    }

    public func fileContents(at path: String) throws -> String {
        guard fileExists(at: fullPath(path)) else {
            throw FileError.noFileFound(path: fullPath(path))
        }

        guard let data = fileManager.contents(atPath: path) else {
            throw FileError.failedToReadData(path: fullPath(path))
        }

        guard let contents = String(data: data, encoding: .utf8) else {
            throw FileError.failedToDecodeData(path: fullPath(path))
        }

        return contents
    }

    public func createFile(at path: String, contents: String? = nil) throws {
        guard !fileExists(at: fullPath(path)) else {
            throw FileError.fileAlreadyExists(path: fullPath(path))
        }

        var contentData: Data?
        if let contents = contents {
            guard let data = contents.data(using: .utf8) else {
                throw FileError.failedToEncodeData(contents: contents)
            }
            contentData = data
        }

        fileManager.createFile(
            atPath: fullPath(path),
            contents: contentData,
            attributes: nil
        )
    }

    public func write(_ contents: String, toFileAt path: String) throws {
        guard fileExists(at: fullPath(path)) else {
            throw FileError.noFileFound(path: fullPath(path))
        }

        let url = URL(fileURLWithPath: fullPath(path))
        do {
            try contents.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            throw FileError.failedToWrite(path: fullPath(path))
        }
    }

    public func createDirectory(path: String) throws {
        let url = URL(fileURLWithPath: fullPath(path))

        try fileManager.createDirectory(
            at: url,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}

// MARK: - FileError

public enum FileError: ChainError {
    case fileAlreadyExists(path: String)
    case failedToDecodeData(path: String)
    case failedToEncodeData(contents: String)
    case failedToReadData(path: String)
    case failedToWrite(path: String)
    case noFileFound(path: String)

    public var description: String {
        let reason: String = {
            switch self {
            case .fileAlreadyExists(let path):
                return "File already exists at \(path)"
            case .failedToDecodeData(let path):
                return "Failed to decode data to string from file: \(path)"
            case .failedToEncodeData(let contents):
            return "Failed to encode contents: \(contents)"
            case .failedToReadData(let path):
                return "Failed to read data from file: \(path)"
            case .failedToWrite(let path):
                return "Failed to write to file: \(path)"
            case .noFileFound(let path):
                return "No file found at \(path)"
            }
        }()

        return "File Error: \(reason)"
    }
}
