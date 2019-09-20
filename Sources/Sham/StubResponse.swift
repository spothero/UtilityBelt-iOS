// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import UtilityBeltNetworking

public struct StubResponse {
    public var data: Data?
    public var error: Error?
    public var statusCode: HTTPStatusCode = .ok
    public var headers: [String: String] = [:]

    /// Determines whether or not the headers in this response are appended to or replace the request headers. Appends by default.
    public var shouldReplaceHeaders: Bool = false

    static func data(_ data: Data) -> Self {
        return self.init(data: data)
    }

    static func error(_ error: Error, statusCode: HTTPStatusCode = .internalServerError, headers: [String: String] = [:]) -> Self {
        return self.init(error: error, statusCode: statusCode, headers: headers)
    }

    static func http(statusCode: HTTPStatusCode = .ok, headers: [String: String] = [:]) -> Self {
        return self.init(statusCode: statusCode, headers: headers)
    }

    static func encodable<T>(_ encodable: T) -> Self where T: Encodable {
        do {
            let data = try JSONEncoder().encode(encodable)
            return self.init(data: data)
        } catch {
            assertionFailure("Unable to encode type \(String(describing: T.self)) for stubbing.")
            return self.init(data: Data())
        }
    }
}
