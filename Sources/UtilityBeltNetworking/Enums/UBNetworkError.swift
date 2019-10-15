// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public enum UBNetworkError: Error {
    case httpClientNotInitialized
    case invalidFilePath(String)
    case invalidURLString(String)
    case invalidURL(URL?)
    case invalidURLResponse
}

extension UBNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .httpClientNotInitialized:
            return "HTTPClient not initialized, request unable to send."
        case let .invalidFilePath(path):
            return "Invalid file path: '\(path)'."
        case let .invalidURLString(urlString):
            return "Invalid URL string: '\(urlString)'."
        case let .invalidURL(.some(url)):
            return "Invalud URL: '\(url.absoluteString)'."
        case .invalidURL(.none):
            return "URL not found."
        case .invalidURLResponse:
            return "Invalid URL Response."
        }
    }
}
