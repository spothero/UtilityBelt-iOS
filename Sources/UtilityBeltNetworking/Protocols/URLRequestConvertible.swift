// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

/// A convenience protocol for converting an object into a `URLRequest`.
public protocol URLRequestConvertible {
    /// Returns a `URLRequest` representation of this object.
    func asURLRequest() throws -> URLRequest
}

extension URLRequest: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        return self
    }
}

extension URL: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        return URLRequest(url: self)
    }
}

extension String: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        if let url = URL(string: self) {
            return URLRequest(url: url)
        } else {
            throw UBNetworkError.invalidURLString(self)
        }
    }
}
