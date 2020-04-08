// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public enum UBNetworkError: Error {
    case invalidFilePath(String)
    case invalidURLString(String)
    case invalidURLResponse
    case unableToDecode(String)
    case unexpectedError
}

extension UBNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidFilePath(path):
            return "Invalid file path '\(path)'."
        case let .invalidURLString(urlString):
            return "Invalid URL string '\(urlString)'."
        case .invalidURLResponse:
            return "Invalid URL Response."
        case let .unableToDecode(objectName):
            return "Unable to decode '\(objectName)'."
        case .unexpectedError:
            return "An unexpected error has occurred."
        }
    }
}
