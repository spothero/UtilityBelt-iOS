// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents a Generic Password Keychain Item.
///
/// [Source](https://developer.apple.com/documentation/security/ksecclassgenericpassword)
public final class GenericPasswordKeychainItem: PasswordKeychainItem {
    // MARK: - Properties
    
    /// Contains an account name.
    ///
    /// The attribute key for this property is `kSecAttrAccount`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattraccount)
    public var account: String?
    
    /// Contains the user-defined attributes.
    ///
    /// The attribute key for this property is `kSecAttrGeneric`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrgeneric)
    public var generic: String?
    
    /// Represents the service associated with this item.
    ///
    /// The attribute key for this property is `kSecAttrService`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrservice)
    public var service: String?
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    override public init() {
        super.init()
    }
}
