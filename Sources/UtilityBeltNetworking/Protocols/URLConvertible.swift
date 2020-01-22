// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// A convenience protocol allowing the passing of Strings and other URL compatible classes
/// to be used in places where a URL is typically required.
public protocol URLConvertible {
    /// Returns a URL representation of this object.
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
