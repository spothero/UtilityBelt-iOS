// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Denotes that the class has a specific value to pass as Keychain Data (instead of itself).
public protocol KeychainValueConvertible {
    /// The value to pass into the Keychain's Data attribute.
    var keychainValue: Any { get }
}
