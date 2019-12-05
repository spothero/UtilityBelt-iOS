// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents a Generic Keychain Item.
public class KeychainItem {
    // MARK: - Properties
    
    /// The type of class for the Keychain Item.
    /// Required.
    ///
    /// The attribute key for this property is `kSecClass`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_class_keys_and_values#1678477)
    public var `class`: KeychainClass
    
    /// The data to store for this Keychain Item.
    /// Required.
    ///
    /// The attribute key for this property is `kSecValueData`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecvaluedata)
    public var data: Data

//    #if os(OSX)
//        /// An access instance indicating access control list settings for this item.
//        /// Mutually exclusive with the `kSecAttrAccessControl` attribute.
//        /// Only available on macOS.
//        ///
//        /// The attribute key for this property is `kSecAttrAccess`.
//        ///
//        /// [Source](https://developer.apple.com/documentation/security/ksecattraccess)
//        public var access: String?
//    #endif
//
//    /// An access control instance indicating access control settings for the item.
//    /// Mutually exclusive with the `kSecAttrAccess` attribute.
//    ///
//    /// The attribute key for this property is `kSecAttrAccessControl`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattraccesscontrol)
//    public var accessControl: String?

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
    public var accessGroup: String?

//    /// Indicates when your app needs access to the data in a keychain item.
//    /// Only available on macOS if true for `kSecUseDataProtectionKeychain` or `kSecAttrSynchronizable`.
//    ///
//    /// The attribute key for this property is `kSecAttrAccessible`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattraccessible)
//    public var accessible: String?
//
//    /// Contains the user-editable comment for this item.
//    ///
//    /// The attribute key for this property is `kSecAttrComment`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrcomment)
//    public var comment: String?
//
//    /// Represents the date the item was created.
//    /// Read only.
//    ///
//    /// The attribute key for this property is `kSecAttrCreationDate`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrcreationdate)
//    public internal(set) var creationDate: Date?
//
//    /// Represents the item's creator.
//    /// This number is the unsigned integer representation of a four-character code (for example, 'aCrt').
//    ///
//    /// The attribute key for this property is `kSecAttrModificationDate`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrcreator)
//    public var creator: UInt8?
//
//    /// Specifies a user-visible string describing this kind of item (for example, "Disk image password").
//    ///
//    /// The attribute key for this property is `kSecAttrDescription`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrdescription)
//    public var description: String?
//
//    /// Indicates the item's visibility.
//    /// True if the item is invisible (that is, should not be displayed).
//    ///
//    /// The attribute key for this property is `kSecAttrIsInvisible`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrisinvisible)
//    public var isInvisible: Bool?
//
//    /// Indicates whether there is a valid password associated with this keychain item.
//    /// This is useful if your application doesn't want a password for some particular service
//    /// to be stored in the keychain, but prefers that it always be entered by the user.
//    ///
//    /// The attribute key for this property is `kSecAttrIsNegative`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrisnegative)
//    public var isNegative: Bool?
//
    /// Contains the user-visible label for this item.
    /// On key creation, if not explicitly specified, this attribute defaults to NULL.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrLabel`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrlabel)
    public var label: String?
//
//    /// Represents the date the item was last modified.
//    /// Read only.
//    ///
//    /// The attribute key for this property is `kSecAttrModificationDate`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrmodificationdate)
//    public internal(set) var modificationDate: Date?
//
//    /// Indicates whether the item is synchronized through iCloud.
//    ///
//    /// The attribute key for this property is `kSecAttrSynchronizable`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrsynchronizable)
//    public var synchronizable: Bool?
//
//    /// Can be used to help distinguish Sync Views when defining their queries.
//    ///
//    /// The attribute key for this property is `kSecAttrSyncViewHint`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrsyncviewhint)
//    public var syncViewHint: String?
//
//    /// Represents the item's type.
//    /// This number is the unsigned integer representation of a four-character code (for example, 'aTyp').
//    ///
//    /// The attribute key for this property is `kSecAttrType`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrtype)
//    public var type: UInt8?

    // MARK: - Methods

    // MARK: Initializers

    internal init(class keychainClass: KeychainClass, data: Data, accessGroup: String? = nil) {
        self.accessGroup = accessGroup
        self.class = keychainClass
        self.data = data
    }
    
    // MARK: Converters
    
    internal func asDictionary() -> [KeychainAttribute: Any?] {
        var query = [KeychainAttribute: Any?]()
        
        query[.class] = self.class
        query[.data] = self.data
        query[.accessGroup] = self.accessGroup
        query[.label] = self.label
        
        #warning("You were figuring out how to add Class and Data into this, as well as result types!")
        // https://developer.apple.com/documentation/security/1401659-secitemadd

        //            var query: [String: Any] = [:]
        //            query[String(kSecClass)] = KeychainClass.internetPassword.rawValue
        //
        //            query[KeychainAttribute.Password.authenticationType.rawValue] = self.authenticationType.rawValue
        //            query[KeychainAttribute.Password.path.rawValue] = self.path
        //            query[KeychainAttribute.Password.port.rawValue] = self.port
        //            query[KeychainAttribute.Password.protocol.rawValue] = self.protocol.rawValue
        //            query[KeychainAttribute.Password.securityDomain.rawValue] = self.securityDomain
        //            query[KeychainAttribute.Password.server.rawValue] = self.server
        //
        //            return query
        
        return query
    }
    
    /// Converts the Keychain Item into a query dictionary that can be used with Keychain Services.
    internal final func asQuery() -> [String: Any] {
        return self.asDictionary().pruneAndStringify()
    }
}

// MARK: - Extensions

fileprivate extension Dictionary where Key == KeychainAttribute, Value == Any? {
    /// Removes all nil values and converts the key from an enum into its raw string value.
    func pruneAndStringify() -> [String: Any] {
        var stringifiedDictionary = [String: Any]()
        
        for (key, value) in self {
            guard let value = value else {
                continue
            }
            
            stringifiedDictionary[key.rawValue] = value
        }
        
        return stringifiedDictionary
    }
}
