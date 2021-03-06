// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

/// A convenience protocol for converting an object into a `URL`.
public protocol URLConvertible {
    /// Returns a `URL` representation of this object.
    func asURL() throws -> URL
}

extension URL: URLConvertible {
    public func asURL() throws -> URL {
        return self
    }
}

extension String: URLConvertible {
    public func asURL() throws -> URL {
        if let url = URL(string: self) {
            return url
        } else {
            throw UBNetworkError.invalidURLString(self)
        }
    }
}
