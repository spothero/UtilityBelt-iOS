// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public extension StringEncodable {
    /// The encoded value of the object in String form.
    /// - Throws: Throws an error if unable to encode.
    /// - Returns: The encoded value of the object in String form.
    func encodedAsString() throws -> String? {
        let encodedValue = try JSONEncoder().encode(self)
        return String(data: encodedValue, encoding: .utf8)
    }
}
