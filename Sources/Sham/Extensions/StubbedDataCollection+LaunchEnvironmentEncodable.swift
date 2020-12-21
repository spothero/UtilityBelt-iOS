// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension StubbedDataCollection: LaunchEnvironmentEncodable {
    /// The key used to save and retrieve the object in the launch environment.
    public static var launchEnvironmentKey = "mocked-data"
    // The encoded value of the object in String form, throws an error if unable to encode.
    public func encodedAsString() throws -> String? {
        let encodedValue = try JSONEncoder().encode(self)
        return String(data: encodedValue, encoding: .utf8)
    }
}
