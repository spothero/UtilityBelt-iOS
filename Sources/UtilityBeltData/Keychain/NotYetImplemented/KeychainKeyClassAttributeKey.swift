// Copyright © 2019 SpotHero, Inc. All rights reserved.

//// Copyright © 2019 SpotHero, Inc. All rights reserved.
//
// import Foundation
//
///// Specifies the value of a keychain item's cryptographic key class.
///// Maps to possible values for use with the `kSecAttrKeyClass` key.
/////
///// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#1679052)
// public enum KeychainKeyClassAttributeKey: RawRepresentable {
//    /// A public key of a public-private pair.
//    case `public`
//    /// A private key of a public-private pair
//    case `private`
//    /// A private key used for symmetric-key encryption and decryption
//    case symmetric
//
//    public init?(rawValue: String) {
//        switch rawValue {
//        case String(kSecAttrKeyClassPrivate):
//            self = .private
//        case String(kSecAttrKeyClassPublic):
//            self = .public
//        case String(kSecAttrKeyClassSymmetric):
//            self = .symmetric
//        default:
//            return nil
//        }
//    }
//
//    public var rawValue: String {
//        switch self {
//        case .private:
//            return String(kSecAttrKeyClassPrivate)
//        case .public:
//            return String(kSecAttrKeyClassPublic)
//        case .symmetric:
//            return String(kSecAttrKeyClassSymmetric)
//        }
//    }
// }
