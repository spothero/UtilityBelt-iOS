// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// An object that can be encoded into a string value.
public protocol StringEncodable {
    /// The object encoded into a string value.
    func encodedAsString() throws -> String?
}
