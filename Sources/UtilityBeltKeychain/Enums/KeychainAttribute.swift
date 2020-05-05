// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// An enum representing all attributes that can be set in Keychain Items.
///
/// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values)
public enum KeychainAttribute {
    // MARK: Class
    
    /// A key representing the keychain item's class, represented by values in the `kSecClass` key.
    case `class`
    
    // MARK: General
    
    // Attributes that can be set in all Keychain Items.
    // Source: https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#1678541
    
    #if os(OSX)
        /// A key whose value in an access instance indicating access control list settings for this item.
        case access
    #endif
    
    /// A key whose value in an access control instance indicating access control settings for the item.
    case accessControl
    /// A key whose value indicates when a keychain item is accessible.
    case accessible
    /// A key whose value is a string indicating the access group an item is in.
    case accessGroup
    /// A key whose value is a string indicating a comment associated with the item.
    case comment
    /// A key whose value indicates the item's creation date.
    case creationDate
    /// A key whose value indicates the item's creator.
    case creator
    /// A key whose value is a string indicating the item's description.
    case description
    /// A key whose value is a Boolean indicating the item's visibility.
    case isInvisible
    /// A key whose value is a Boolean indicating whether the item has a valid password.
    case isNegative
    /// A key whose value is a string indicating the item's label.
    case label
    /// A key whose value indicates the item's last modification date.
    case modificationDate
    /// A key whose value is a string indicating whether the item is synchronized through iCloud.
    case synchronizable
    /// A key whose value is a string that provides a sync view hint.
    case syncViewHint
    /// A key whose value indicates the item's type.
    case type
    
    // MARK: Password
    
    // Attributes that can be set in Keychain Items of class `kSecClassGenericPassword` and `kSecClassInternetPassword`.
    // Source: https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#2882540
    
    /// A key whose value is a string indicating the item's account name.
    case account
    /// A key whose value indicates the item's authentication scheme.
    case authenticationType
    /// A key whose value indicates the item's user-defined attributes.
    case generic
    /// A key whose value is a string indicating the item's path attribute.
    case path
    /// A key whose value indicates the item's port.
    case port
    /// A key whose value indicates the item's protocol.
    case `protocol`
    /// A key whose value is a string indicating the item's security domain.
    case securityDomain
    /// A key whose value is a string indicating the item's server.
    case server
    /// A key whose value is a string indicating the item's service.
    case service
    
    // MARK: Value
    
    /// A key whose value is the item's data.
    case data
    /// A key whose value is a persistent reference to the item.
    case persistentReference
    /// A key whose value is a reference to the item.
    case reference
    
    // MARK: Result
    
    /// A key whose value is a Boolean indicating whether or not to return item attributes.
    case returnAttributes
    /// A key whose value is a Boolean indicating whether or not to return item data.
    case returnData
    /// A key whose value is a Boolean indicating whether or not to return a persistent reference to an item.
    case returnPersistentReference
    /// A key whose value is a Boolean indicating whether or not to return a reference to an item.
    case returnReference
    
    // MARK: Matching
    
    // TODO: There are many more search attributes we could add!
    // Source: https://developer.apple.com/documentation/security/keychain_services/keychain_items/search_attribute_keys_and_values
    
    /// A key whose value indicates the match limit.
    case matchLimit
}

// MARK: - RawRepresentable

extension KeychainAttribute: RawRepresentable {
    // MARK: RawValue
    
    public var rawValue: String {
        switch self {
        #if os(OSX)
            // swiftlint:disable:next switch_case_alignment
            case .access:
                return String(kSecAttrAccess)
        #endif
            
        // Class
        case .class:
            return String(kSecClass)
            
        // General
        case .accessControl:
            return String(kSecAttrAccessControl)
        case .accessible:
            return String(kSecAttrAccessible)
        case .accessGroup:
            return String(kSecAttrAccessGroup)
        case .comment:
            return String(kSecAttrComment)
        case .creationDate:
            return String(kSecAttrCreationDate)
        case .creator:
            return String(kSecAttrCreator)
        case .description:
            return String(kSecAttrDescription)
        case .isInvisible:
            return String(kSecAttrIsInvisible)
        case .isNegative:
            return String(kSecAttrIsNegative)
        case .label:
            return String(kSecAttrLabel)
        case .modificationDate:
            return String(kSecAttrModificationDate)
        case .synchronizable:
            return String(kSecAttrSynchronizable)
        case .syncViewHint:
            return String(kSecAttrSyncViewHint)
        case .type:
            return String(kSecAttrType)
            
        // Password
        case .account:
            return String(kSecAttrAccount)
        case .authenticationType:
            return String(kSecAttrAuthenticationType)
        case .generic:
            return String(kSecAttrGeneric)
        case .path:
            return String(kSecAttrPath)
        case .port:
            return String(kSecAttrPort)
        case .protocol:
            return String(kSecAttrProtocol)
        case .securityDomain:
            return String(kSecAttrSecurityDomain)
        case .server:
            return String(kSecAttrServer)
        case .service:
            return String(kSecAttrService)
            
        // Value
        case .data:
            return String(kSecValueData)
        case .persistentReference:
            return String(kSecValuePersistentRef)
        case .reference:
            return String(kSecValueRef)
            
        // Return
        case .returnAttributes:
            return String(kSecReturnAttributes)
        case .returnData:
            return String(kSecReturnData)
        case .returnPersistentReference:
            return String(kSecReturnPersistentRef)
        case .returnReference:
            return String(kSecReturnRef)
            
        // Matching
        case .matchLimit:
            return String(kSecMatchLimit)
        }
    }
    
    // MARK: Initializer
    
    public init?(rawValue: String) {
        switch rawValue {
        #if os(OSX)
            // swiftlint:disable:next switch_case_alignment
            case String(kSecAttrAccess):
                self = .access
        #endif
            
        // Class
        case String(kSecClass):
            self = .class
            
        // General
        case String(kSecAttrAccessControl):
            self = .accessControl
        case String(kSecAttrAccessible):
            self = .accessible
        case String(kSecAttrAccessGroup):
            self = .accessGroup
        case String(kSecAttrComment):
            self = .comment
        case String(kSecAttrCreationDate):
            self = .creationDate
        case String(kSecAttrCreator):
            self = .creator
        case String(kSecAttrDescription):
            self = .description
        case String(kSecAttrIsInvisible):
            self = .isInvisible
        case String(kSecAttrIsNegative):
            self = .isNegative
        case String(kSecAttrLabel):
            self = .label
        case String(kSecAttrModificationDate):
            self = .modificationDate
        case String(kSecAttrSynchronizable):
            self = .synchronizable
        case String(kSecAttrSyncViewHint):
            self = .syncViewHint
        case String(kSecAttrType):
            self = .type
            
        // Password
        case String(kSecAttrAccount):
            self = .account
        case String(kSecAttrAuthenticationType):
            self = .authenticationType
        case String(kSecAttrGeneric):
            self = .generic
        case String(kSecAttrPath):
            self = .path
        case String(kSecAttrPort):
            self = .port
        case String(kSecAttrProtocol):
            self = .protocol
        case String(kSecAttrSecurityDomain):
            self = .securityDomain
        case String(kSecAttrServer):
            self = .server
        case String(kSecAttrService):
            self = .service
            
        // Value
        case String(kSecValueData):
            self = .data
        case String(kSecValuePersistentRef):
            self = .persistentReference
        case String(kSecValueRef):
            self = .reference
            
        // Return
        case String(kSecReturnAttributes):
            self = .returnAttributes
        case String(kSecReturnData):
            self = .returnData
        case String(kSecReturnPersistentRef):
            self = .returnPersistentReference
        case String(kSecReturnRef):
            self = .returnReference
            
        // Matching
        case String(kSecMatchLimit):
            self = .matchLimit
            
        default:
            return nil
        }
    }
}
