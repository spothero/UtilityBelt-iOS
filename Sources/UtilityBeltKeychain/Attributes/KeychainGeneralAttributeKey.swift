// Copyright © 2019 SpotHero, Inc. All rights reserved.

//// Copyright © 2019 SpotHero, Inc. All rights reserved.
//
// import Foundation
//
///// Specifies the key for a general attribute of a keychain item.
/////
///// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#1678541)
// public enum KeychainGeneralItemAttributeKey: RawRepresentable {
//    #if os(OSX)
//    /// A key whose value in an access instance indicating access control list settings for this item.
//    case access
//    #endif
//
//    /// A key whose value in an access control instance indicating access control settings for the item.
//    case accessControl
//    /// A key whose value indicates when a keychain item is accessible.
//    case accessible
//    /// A key whose value is a string indicating the access group an item is in.
//    case accessGroup
//    /// A key whose value is a string indicating a comment associated with the item.
//    case comment
//    /// A key whose value indicates the item's creation date.
//    case creationDate
//    /// A key whose value indicates the item's creator.
//    case creator
//    /// A key whose value is a string indicating the item's description.
//    case description
//    /// A key whose value is a Boolean indicating the item's visibility.
//    case isInvisible
//    /// A key whose value is a Boolean indicating whether the item has a valid password.
//    case isNegative
//    /// A key whose value is a string indicating the item's label.
//    case label
//    /// A key whose value indicates the item's last modification date.
//    case modificationDate
//    /// A key whose value is a string indicating whether the item is synchronized through iCloud.
//    case synchronizable
//    /// A key whose value is a string that provides a sync view hint.
//    case syncViewHint
//    /// A key whose value indicates the item's type.
//    case type
//
//    public var rawValue: String {
//        switch self {
//        case .accessControl:
//            return String(kSecAttrAccessControl)
//        case .accessible:
//            return String(kSecAttrAccessible)
//        case .accessGroup:
//            return String(kSecAttrAccessGroup)
//        case .comment:
//            return String(kSecAttrComment)
//        case .creationDate:
//            return String(kSecAttrCreationDate)
//        case .creator:
//            return String(kSecAttrCreator)
//        case .description:
//            return String(kSecAttrDescription)
//        case .isInvisible:
//            return String(kSecAttrIsInvisible)
//        case .isNegative:
//            return String(kSecAttrIsNegative)
//        case .label:
//            return String(kSecAttrLabel)
//        case .modificationDate:
//            return String(kSecAttrModificationDate)
//        case .synchronizable:
//            return String(kSecAttrSynchronizable)
//        case .syncViewHint:
//            return String(kSecAttrSyncViewHint)
//        case .type:
//            return String(kSecAttrType)
//        }
//    }
//
//    public init?(rawValue: String) {
//        switch rawValue {
//        #if os(OSX)
//        case String(kSecAttrAccess):
//            self = .access
//        #endif
//        case String(kSecAttrAccessControl):
//            self = .accessControl
//        case String(kSecAttrAccessible):
//            self = .accessible
//        case String(kSecAttrAccessGroup):
//            self = .accessGroup
//        case String(kSecAttrComment):
//            self = .comment
//        case String(kSecAttrCreationDate):
//            self = .creationDate
//        case String(kSecAttrCreator):
//            self = .creator
//        case String(kSecAttrDescription):
//            self = .description
//        case String(kSecAttrIsInvisible):
//            self = .isInvisible
//        case String(kSecAttrIsNegative):
//            self = .isNegative
//        case String(kSecAttrLabel):
//            self = .label
//        case String(kSecAttrModificationDate):
//            self = .modificationDate
//        case String(kSecAttrSynchronizable):
//            self = .synchronizable
//        case String(kSecAttrSyncViewHint):
//            self = .syncViewHint
//        case String(kSecAttrType):
//            self = .type
//        default:
//            return nil
//        }
//    }
// }
