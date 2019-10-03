// Copyright © 2019 SpotHero, Inc. All rights reserved.

/// The method by which parameters are encoded for an HTTP request.
public enum ParameterEncoding {
    /// Parameters are put into the HTTP body of the request.
    case httpBody(HTTPBodyEncoding)
    /// Parameters are put into the query string of the URL.
    case queryString

    /// Returns the default encoding for a given HTTP method.
    static func defaultEncoding(for method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .delete, .get, .head:
            return .queryString
        case .connect, .options, .patch, .post, .put, .trace:
            return .httpBody(.json)
        }
    }
}
