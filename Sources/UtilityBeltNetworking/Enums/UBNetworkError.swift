// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public enum UBNetworkError: Error {
    case invalidFilePath(String)
    case invalidURLString(String)
    case invalidURL(URL?)
    case invalidURLResponse
}

extension UBNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidFilePath(path):
            return "Invalid file path: '\(path)'."
        case let .invalidURLString(urlString):
            return "Invalid URL string: '\(urlString)'."
        case let .invalidURL(.some(url)):
            return "Invalud URL: '\(url.absoluteString)'."
        case let .invalidURL(.none):
            return "URL not found."
        case .invalidURLResponse:
            return "Invalid URL Response."
        }
    }
}
