// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents a base Keychain.
class KeychainConfiguration {
    // MARK: - Properties
    
    /// The type of class for the Keychain Item.
    /// Required.
    ///
    /// The attribute key for this property is `kSecClass`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_class_keys_and_values#1678477)
    let `class`: KeychainClass
    
    /// Indicates the item’s one and only access group.
    /// Only available on macOS if true for `kSecUseDataProtectionKeychain` or `kSecAttrSynchronizable`.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrAccessGroup`.
    ///
    /// For an app to access a keychain item, one of the groups to which the app belongs must be the item’s group.
    /// The list of an app’s access groups consists of the following string identifiers, in this order:
    /// - The strings in the app’s Keychain Access Groups Entitlement
    /// - The app ID string
    /// - The strings in the App Groups Entitlement
    /// Two or more apps that are in the same access group can share keychain items.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattraccessgroup)
    let accessGroup: String?
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    init(class keychainClass: KeychainClass, accessGroup: String? = nil) {
        self.accessGroup = accessGroup
        self.class = keychainClass
    }
    
    // MARK: Converters
    
    func asDictionary() -> [KeychainAttribute: Any?] {
        var query = [KeychainAttribute: Any?]()
        
        query[.class] = self.class.rawValue
        query[.accessGroup] = self.accessGroup
        
        return query
    }
}
