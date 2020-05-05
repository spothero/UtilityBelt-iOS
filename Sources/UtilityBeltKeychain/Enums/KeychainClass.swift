// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// Specifies the value of a keychain item's class.
/// Maps to possible values for use with the `kSecClass` key.
///
/// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_class_keys_and_values#1678477)
public enum KeychainClass: RawRepresentable {
    /// The value that indicates a certificate item.
    case certificate
    
    /// The value that indicates a generic password item.
    case genericPassword
    
    /// The value that indicates an identity item.
    ///
    /// An identity is a certificate paired with its associated private key.
    /// Because an identity is the combination of a private key and a certificate,
    /// this class shares attributes of both `kSecClassKey` and `kSecClassCertificate`.
    case identity
    
    /// The value that indicates an Internet password item.
    case internetPassword
    
    /// The value that indicates a cryptographic key item.
    case key
    
    public var rawValue: String {
        switch self {
        case .certificate:
            return String(kSecClassCertificate)
        case .genericPassword:
            return String(kSecClassGenericPassword)
        case .identity:
            return String(kSecClassIdentity)
        case .internetPassword:
            return String(kSecClassInternetPassword)
        case .key:
            return String(kSecClassKey)
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecClassCertificate):
            self = .certificate
        case String(kSecClassGenericPassword):
            self = .genericPassword
        case String(kSecClassIdentity):
            self = .identity
        case String(kSecClassInternetPassword):
            self = .internetPassword
        case String(kSecClassKey):
            self = .key
        default:
            return nil
        }
    }
}
