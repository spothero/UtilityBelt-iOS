// Copyright © 2019 SpotHero, Inc. All rights reserved.

/// Determines the method by which parameters are encoded when sent via HTTP bodies.
public enum HTTPBodyEncoding {
    /// Encodes the HTTP body as application/json.
    case json
    /// Encodes the HTTP body as application/x-www-form-urlencoded.
    case wwwFormURLEncoded
}
