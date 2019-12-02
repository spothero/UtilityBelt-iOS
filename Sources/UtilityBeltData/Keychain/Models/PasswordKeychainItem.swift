// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents a Password Keychain Item.
public class PasswordKeychainItem: KeychainItem {
    // MARK: - Properties

    /// Contains an account name.
    ///
    /// The attribute key for this property is `kSecAttrAccount`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattraccount)
    public var account: String?

    // MARK: - Methods

    // MARK: Initializers

    override init() {}
}
