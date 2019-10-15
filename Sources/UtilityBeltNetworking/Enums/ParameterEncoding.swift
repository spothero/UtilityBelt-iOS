// Copyright © 2019 SpotHero, Inc. All rights reserved.

/// The method by which parameters are encoded for an HTTP request.
public enum ParameterEncoding {
    /// Parameters are put into the HTTP body of the request.
    case httpBody(HTTPBodyEncoding)
    /// Parameters are put into the query string of the URL.
    case queryString
    /// Parameters use the default encoding for the HTTP method of the request.
    case defaultEncodingForMethod
}
