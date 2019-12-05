// Copyright © 2019 SpotHero, Inc. All rights reserved.

//
// import Foundation
//
///// Specifies the value of a keychain item's cryptographic key algorithm.
///// Maps to possible values for use with the `kSecAttrKeyType` key.
/////
///// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#1679067)
// public enum KeychainKeyTypeAttributeKey: RawRepresentable {
//    /// Elliptic curve algorithm.
//    @available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *)
//    case ecsecPrimeRandom
//    /// RSA algorithm.
//    case rsa
//
//    #if os(OSX)
//    /// AES algorithm.
//    case aes
//    /// CAST algorithm.
//    case cast
//    /// DES algorithm.
//    case des
//    /// DSA algorithm.
//    case dsa
//    /// Elliptic curve algorithm.
//    @available(*, unavailable, message: "Deprecated. Use ecsecPrimeRandom instead.")
//    case ec
//    /// Elliptic curve DSA algorithm.
//    @available(*, unavailable, message: "Deprecated. Use ecsecPrimeRandom instead.")
//    case ecdsa
//    /// RC2 algorithm.
//    case rc2
//    /// RC4 algorithm.
//    case rc4
//    /// 3DES algorithm.
//    case threeDES
//    #endif
//
//    public init?(rawValue: String) {
//        switch rawValue {
//        case String(kSecAttrKeyTypeECSECPrimeRandom):
//            self = .ecsecPrimeRandom
//        case String(kSecAttrKeyTypeRSA):
//            self = .rsa
//        #if os(OSX)
//        case String(kSecAttrKeyTypeAES):
//            self = .aes
//        case String(kSecAttrKeyTypeCAST):
//            self = .cast
//        case String(kSecAttrKeyTypeDES):
//            self = .des
//        case String(kSecAttrKeyTypeDSA):
//            self = .dsa
//        case String(kSecAttrKeyTypeRC2):
//            self = .rc2
//        case String(kSecAttrKeyTypeRC4):
//            self = .rc4
//        case String(kSecAttrKeyType3DES):
//            self = .threeDES
//        #endif
//        default:
//            return nil
//        }
//    }
//
//    public var rawValue: String {
////        #if os(iOS)
//        switch self {
//        case .ecsecPrimeRandom:
//            <#code#>
//        case .rsa:
//            <#code#>
//        case .aes:
//            return
//        }
////        #elseif os(OSX)
////        switch self {
////        case .ecsecPrimeRandom:
////            <#code#>
////        case .rsa:
////            <#code#>
////        case .aes:
////            <#code#>
////        case .cast:
////            <#code#>
////        case .des:
////            <#code#>
////        case .dsa:
////            <#code#>
////        case .rc2:
////            <#code#>
////        case .rc4:
////            <#code#>
////        case .threeDES:
////            <#code#>
////        }
////        #endif
//    }
// }
