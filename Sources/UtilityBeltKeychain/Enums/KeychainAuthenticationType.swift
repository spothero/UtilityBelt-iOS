// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// Specifies the value of an Internet Password Keychain Item's authentication scheme.
/// Maps to possible values for use with the `kSecAttrAuthenticationType` key.
///
/// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#1679017)
public enum KeychainAuthenticationType: RawRepresentable {
    /// The default authentication type.
    case `default`
    /// Distributed Password authentication.
    case dpa
    /// HTML form based authentication.
    case htmlForm
    /// HTTP Basic authentication.
    case httpBasic
    /// HTTP Digest Access authentication.
    case httpDigest
    /// Microsoft Network default authentication.
    case msn
    /// Windows NT LAN Manager authentication.
    case ntlm
    /// Remote Password authentication.
    case rpa
    
    public var rawValue: String {
        switch self {
        case .default:
            return String(kSecAttrAuthenticationTypeDefault)
        case .dpa:
            return String(kSecAttrAuthenticationTypeDPA)
        case .htmlForm:
            return String(kSecAttrAuthenticationTypeHTMLForm)
        case .httpBasic:
            return String(kSecAttrAuthenticationTypeHTTPBasic)
        case .httpDigest:
            return String(kSecAttrAuthenticationTypeHTTPDigest)
        case .msn:
            return String(kSecAttrAuthenticationTypeMSN)
        case .ntlm:
            return String(kSecAttrAuthenticationTypeNTLM)
        case .rpa:
            return String(kSecAttrAuthenticationTypeRPA)
        }
    }
    
    public init?(rawValue: String) {
        switch rawValue {
        case String(kSecAttrAuthenticationTypeDefault):
            self = .default
        case String(kSecAttrAuthenticationTypeDPA):
            self = .dpa
        case String(kSecAttrAuthenticationTypeHTMLForm):
            self = .htmlForm
        case String(kSecAttrAuthenticationTypeHTTPBasic):
            self = .httpBasic
        case String(kSecAttrAuthenticationTypeHTTPDigest):
            self = .httpDigest
        case String(kSecAttrAuthenticationTypeMSN):
            self = .msn
        case String(kSecAttrAuthenticationTypeNTLM):
            self = .ntlm
        case String(kSecAttrAuthenticationTypeRPA):
            self = .rpa
        default:
            self = .default
        }
    }
}
