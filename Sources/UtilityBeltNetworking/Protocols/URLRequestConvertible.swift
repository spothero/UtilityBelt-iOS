// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// A convenience protocol allowing the passing of Strings, URLs, and other URLRequest compatible classes
/// to be used in places where a URLRequest is typically required.
public protocol URLRequestConvertible {
    /// Returns a URLRequest representation of this object.
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

extension HTTPRequest: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        if let url = self.url {
            var request = URLRequest(url: url)
            request.httpMethod = self.method.rawValue
            request.setParameters(self.parameters, method: self.method, encoding: self.parameterEncoding)

            return request
        } else {
            throw UBNetworkError.invalidURL(self.url)
        }
    }
}
