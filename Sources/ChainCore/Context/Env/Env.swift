//
//  Env.swift
//  ChainCore
//
//  Created by Billy Irwin on 11/22/20.
//

import Foundation

public typealias EnvVar = String

// MARK: - Env

public protocol Env {

    func get<T>(_ type: T.Type, for variable: EnvVar) throws -> T
}

extension Env {

    public func get(_ variable: EnvVar) throws -> String {
        return try get(String.self, for: variable)
    }

    public func isEnabled(_ variable: EnvVar) -> Bool {
        do {
            return try get(Bool.self, for: variable)
        } catch {
            return false
        }
    }
}

// MARK: - EnvError

public enum EnvError: Error {
    case variableNotFound(variable: EnvVar)
    case invalidVariableType(variable: EnvVar, expected: AnyClass, found: AnyClass)
}

// MARK: - EnvClient

public class EnvClient: Env {

    public func get<T>(_ type: T.Type, for variable: EnvVar) throws -> T {
        guard let value = ProcessInfo.processInfo.environment[variable] else {
            throw EnvError.variableNotFound(variable: variable)
        }

        guard let typeValue = value as? T else {
            // TODO fix this
            throw EnvError.variableNotFound(variable: variable)
//
//            throw EnvError.invalidVariableType(
//                variable: variable,
//                expected: T.Type,
//                found: type(of: value)
//            )
        }

        return typeValue
    }
}
