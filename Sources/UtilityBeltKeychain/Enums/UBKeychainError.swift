// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public enum UBKeychainError: Error {
    case couldNotConvertStringToData
    case unhandled(message: String)
}

extension UBKeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .couldNotConvertStringToData:
            return "Could not convert String to Data."
        case let .unhandled(message):
            return message
        }
    }
}
