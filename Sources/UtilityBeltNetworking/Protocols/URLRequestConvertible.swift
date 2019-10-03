//
//  File.swift
//
//
//  Created by Brian Drelling on 10/3/19.
//

import Foundation

public protocol URLRequestConvertible {
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
            throw UBError.invalidURLString(self)
        }
    }
}
