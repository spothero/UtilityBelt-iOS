// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents a Generic Password Keychain.
///
/// [Source](https://developer.apple.com/documentation/security/ksecclassgenericpassword)
final class GenericPasswordKeychainConfiguration: KeychainConfiguration {
    // MARK: - Properties
    
    /// Represents the service associated with this item.
    ///
    /// The attribute key for this property is `kSecAttrService`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrservice)
    let service: String
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    init(service: String, accessGroup: String? = nil) {
        self.service = service
        
        super.init(class: .genericPassword, accessGroup: accessGroup)
    }
    
    // MARK: Converters
    
    override func asDictionary() -> [KeychainAttribute: Any?] {
        var query = super.asDictionary()
        
        query[.service] = self.service
        
        return query
    }
}
