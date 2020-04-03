// Copyright © 2020 SpotHero, Inc. All rights reserved.

/// The method by which parameters are encoded for an HTTP request.
public enum ParameterEncoding {
    /// Parameters use the default encoding for the HTTP method of the request.
    case defaultEncodingForMethod
    /// Parameters are put into the HTTP body of the request.
    case httpBody(HTTPBodyEncoding)
    /// Parameters are put into the query string of the URL.
    case queryString

    /// Resolves the encoding type, factoring into account the HTTP method for a request (if applicable).
    public func resolvedEncoding(for method: HTTPMethod) -> ParameterEncoding {
        switch self {
        case .defaultEncodingForMethod:
            return method.defaultParameterEncoding
        default:
            return self
        }
    }
}
