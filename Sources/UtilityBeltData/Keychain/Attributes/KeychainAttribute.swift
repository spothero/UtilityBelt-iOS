// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// A struct segmented by different enums that represent attributes to be used in Keychain Item querying.
public struct KeychainAttribute {
    /// Attributes that can be set in all Keychain Items.
    ///
    /// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#1678541)
    public enum General: RawRepresentable {
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

        public var rawValue: String {
            switch self {
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
            }
        }

        public init?(rawValue: String) {
            #if os(OSX)
            // `kSecAttrAccess` only exists on macOS
            // Pulling this check out of the switch statement prevents bad formatting
            if rawValue == String(kSecAttrAccess) {
                return .access
            }
            #endif
            
            switch rawValue {
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
            default:
                return nil
            }
        }
    }

    /// Attributes that can be set in Keychain Items of class `kSecClassGenericPassword` and `kSecClassInternetPassword`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#2882540)
    public enum Password: RawRepresentable {
        /// A key whose value is a string indicating the item's account name.
        case account
        /// A key whose value indicates the item's authentication scheme.
        case authenticationType
        /// A key whose value is a string indicating the item's service.
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

        public var rawValue: String {
            switch self {
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
            }
        }

        public init?(rawValue: String) {
            switch rawValue {
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
            default:
                return nil
            }
        }
    }
}
