// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents a Password Keychain Item.
public class PasswordKeychainItem {
    // MARK: - Properties
    
    #if os(OSX)
    /// An access instance indicating access control list settings for this item.
    /// Mutually exclusive with the `kSecAttrAccessControl` attribute.
    /// Only available on macOS.
    ///
    /// The attribute key for this property is `kSecAttrAccess`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattraccess)
    public var access: String?
    #endif
    
    /// An access control instance indicating access control settings for the item.
    /// Mutually exclusive with the `kSecAttrAccess` attribute.
    ///
    /// The attribute key for this property is `kSecAttrAccessControl`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattraccesscontrol)
    public var accessControl: String?
    
    /// Indicates the item’s one and only access group.
    /// Only available on macOS if true for `kSecUseDataProtectionKeychain` or `kSecAttrSynchronizable`.
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
    
    /// Indicates when your app needs access to the data in a keychain item.
    /// Only available on macOS if true for `kSecUseDataProtectionKeychain` or `kSecAttrSynchronizable`.
    ///
    /// The attribute key for this property is `kSecAttrAccessible`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattraccessible)
    public var accessible: String?
    
    /// Contains an account name.
    ///
    /// The attribute key for this property is `kSecAttrAccount`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattraccount)
    public var account: String?
    
    /// Contains the user-editable comment for this item.
    ///
    /// The attribute key for this property is `kSecAttrComment`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrcomment)
    public var comment: String?
    
    /// Represents the date the item was created. Read only.
    ///
    /// The attribute key for this property is `kSecAttrCreationDate`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrcreationdate)
    public internal(set) var creationDate: Date?
    
    /// Represents the item's creator.
    /// This number is the unsigned integer representation of a four-character code (for example, 'aCrt').
    ///
    /// The attribute key for this property is `kSecAttrModificationDate`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrcreator)
    public var creator: UInt8?
    
    /// Specifies a user-visible string describing this kind of item (for example, "Disk image password").
    ///
    /// The attribute key for this property is `kSecAttrDescription`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrdescription)
    public var description: String?
    
    /// Indicates the item's visibility.
    /// True if the item is invisible (that is, should not be displayed).
    ///
    /// The attribute key for this property is `kSecAttrIsInvisible`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrisinvisible)
    public var isInvisible: Bool?
    
    /// Indicates whether there is a valid password associated with this keychain item.
    /// This is useful if your application doesn't want a password for some particular service
    /// to be stored in the keychain, but prefers that it always be entered by the user.
    ///
    /// The attribute key for this property is `kSecAttrIsNegative`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrisnegative)
    public var isNegative: Bool?
    
    /// Contains the user-visible label for this item.
    /// On key creation, if not explicitly specified, this attribute defaults to NULL.
    ///
    /// The attribute key for this property is `kSecAttrLabel`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrlabel)
    public var label: String?
    
    /// Represents the date the item was last modified. Read only.
    ///
    /// The attribute key for this property is `kSecAttrModificationDate`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrmodificationdate)
    public internal(set) var modificationDate: Date?
    
    /// Indicates whether the item is synchronized through iCloud.
    ///
    /// The attribute key for this property is `kSecAttrSynchronizable`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrsynchronizable)
    public var synchronizable: Bool?
    
    /// Represents the item's type.
    /// This number is the unsigned integer representation of a four-character code (for example, 'aTyp').
    ///
    /// The attribute key for this property is `kSecAttrType`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrtype)
    public var type: UInt8?
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    init() {
        
    }
}
