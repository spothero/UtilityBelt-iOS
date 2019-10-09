//
//  File.swift
//  
//
//  Created by Brian Drelling on 10/8/19.
//

#if canImport(UtilityBeltNetworking)

import UtilityBeltNetworking

public extension HTTPClient {
    /// Convenience initializer for an HTTPClient set up to work with a Sham MockService
    static let sham = HTTPClient(session: .sham)
}

#endif
