// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents a Generic Password Keychain Item.
///
/// [Source](https://developer.apple.com/documentation/security/ksecclassgenericpassword)
public final class GenericPasswordKeychainItem: PasswordKeychainItem {
    // MARK: - Properties

//    /// Contains the user-defined attributes.
//    ///
//    /// The attribute key for this property is `kSecAttrGeneric`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrgeneric)
//    public var generic: Data?

    /// Represents the service associated with this item.
    ///
    /// The attribute key for this property is `kSecAttrService`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrservice)
    public var service: String

    // MARK: - Methods

    // MARK: Initializers

    public init(service: String, account: String, data: Data, accessGroup: String? = nil) {
        self.service = service
        
        super.init(class: .genericPassword, account: account,   data: data, accessGroup: accessGroup)
    }
    
    // MARK: Converters
    
    override internal func asDictionary() -> [KeychainAttribute: Any?] {
        var query = super.asDictionary()
        
        query[.service] = self.service
        
        return query
    }
}
