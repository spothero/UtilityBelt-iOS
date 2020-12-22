// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
import Sham

extension StubbedDataCollection: LaunchEnvironmentEncodable {
    /// The key used to save and retrieve the object in the launch environment.
    public static var launchEnvironmentKey = "mocked-data"
    
    /// The encoded value of the object in String form.
    /// - Throws: Throws an error if unable to encode.
    /// - Returns: The encoded value of the object in String form.
    public func encodedAsString() throws -> String? {
        let encodedValue = try JSONEncoder().encode(self)
        return String(data: encodedValue, encoding: .utf8)
    }
}
