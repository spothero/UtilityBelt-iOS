// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public protocol URLConvertible {
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
            throw UBError.invalidURLString(self)
        }
    }
}
