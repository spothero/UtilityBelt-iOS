// Copyright © 2019 SpotHero, Inc. All rights reserved.

//// Copyright © 2019 SpotHero, Inc. All rights reserved.
//
// import Foundation
//
///// Attributes that can be set in Keychain items of class `kSecClassGenericPassword` and `kSecClassInternetPassword`.
/////
///// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#2882540)
// public enum KeychainPasswordAttributeKey: RawRepresentable {
//    /// A key whose value is a string indicating the item's account name.
//    case account
//    /// A key whose value indicates the item's authentication scheme.
//    case authenticationType
//    /// A key whose value is a string indicating the item's service.
//    case generic
//    /// A key whose value is a string indicating the item's path attribute.
//    case path
//    /// A key whose value indicates the item's port.
//    case port
//    /// A key whose value indicates the item's protocol.
//    case `protocol`
//    /// A key whose value is a string indicating the item's security domain.
//    case securityDomain
//    /// A key whose value is a string indicating the item's server.
//    case server
//    /// A key whose value is a string indicating the item's service.
//    case service
//
//    public var rawValue: String {
//        switch self {
//        case .account:
//            return String(kSecAttrAccount)
//        case .authenticationType:
//            return String(kSecAttrAuthenticationType)
//        case .generic:
//            return String(kSecAttrGeneric)
//        case .path:
//            return String(kSecAttrPath)
//        case .port:
//            return String(kSecAttrPort)
//        case .protocol:
//            return String(kSecAttrProtocol)
//        case .securityDomain:
//            return String(kSecAttrSecurityDomain)
//        case .server:
//            return String(kSecAttrServer)
//        case .service:
//            return String(kSecAttrService)
//        }
//    }
//
//    public init?(rawValue: String) {
//        switch rawValue {
//        case String(kSecAttrAccount):
//            self = .account
//        case String(kSecAttrAuthenticationType):
//            self = .authenticationType
//        case String(kSecAttrGeneric):
//            self = .generic
//        case String(kSecAttrPath):
//            self = .path
//        case String(kSecAttrPort):
//            self = .port
//        case String(kSecAttrProtocol):
//            self = .protocol
//        case String(kSecAttrSecurityDomain):
//            self = .securityDomain
//        case String(kSecAttrServer):
//            self = .server
//        case String(kSecAttrService):
//            self = .service
//        default:
//            return nil
//        }
//    }
// }
