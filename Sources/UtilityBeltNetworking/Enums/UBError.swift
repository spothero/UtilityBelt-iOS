// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public enum UBError: Swift.Error {
    case invalidFilePath(String)
    case invalidURLString(String)
}

extension UBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidFilePath(path):
            return "Invalid file path: '\(path)'."
        case let .invalidURLString(urlString):
            return "Invalid URL string: '\(urlString)'."
        }
    }
}
