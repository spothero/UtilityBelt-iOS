// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public enum UBNetworkError: Error {
    case invalidContentType(String)
    case invalidURLString(String)
    case invalidURLResponse
    case unableToDecode(String, DecodingError?)
    case unexpectedError
}

extension UBNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidContentType(contentType):
            return "Invalid content type '\(contentType)'."
        case let .invalidURLString(urlString):
            return "Invalid URL string '\(urlString)'."
        case .invalidURLResponse:
            return "Invalid URL Response."
        case let .unableToDecode(objectName, .some(underlyingError)):
            return "Unable to decode '\(objectName)'. \(underlyingError.cleanedDescription)"
        case let .unableToDecode(objectName, _):
            return "Unable to decode '\(objectName)'."
        case .unexpectedError:
            return "An unexpected error has occurred."
        }
    }
}
