// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public enum UBKeychainError: Error {
    case couldNotConvertDataToString
    case unhandled(message: String)
}

extension UBKeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .couldNotConvertDataToString:
            return "Could not convert data to string."
        case let .unhandled(message):
            return message
        }
    }
}
