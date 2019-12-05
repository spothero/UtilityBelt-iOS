// Copyright © 2019 SpotHero, Inc. All rights reserved.

//// Copyright © 2019 SpotHero, Inc. All rights reserved.
//
// import Foundation
//
///// Attributes that can be set in Keychain items of class `kSecClassCertificate`.
/////
///// [Source](https://developer.apple.com/documentation/security/keychain_services/keychain_items/item_attribute_keys_and_values#2882541)
// public enum KeychainCertificateAttributeKey: RawRepresentable {
//    /// A key whose value indicates the item's certificate encoding.
//    case certificateEncoding
//    /// A key whose value indicates the item's certificate type.
//    case certificateType
//    /// A key whose value indicates the item's issuer.
//    case issuer
//    /// A key whose value indicates the item's public key hash.
//    case publicKeyHash
//    /// A key whose value indicates the item's serial number.
//    case serialNumber
//    /// A key whose value indicates the item's subject name.
//    case subject
//    /// A key whose value indicates the item's subject key ID.
//    case subjectKeyID
//
//    public init?(rawValue: String) {
//        switch rawValue {
//        case String(kSecAttrCertificateEncoding):
//            self = .certificateEncoding
//        case String(kSecAttrCertificateType):
//            self = .certificateType
//        case String(kSecAttrIssuer):
//            self = .issuer
//        case String(kSecAttrPublicKeyHash):
//            self = .publicKeyHash
//        case String(kSecAttrSerialNumber):
//            self = .serialNumber
//        case String(kSecAttrSubject):
//            self = .subject
//        case String(kSecAttrSubjectKeyID):
//            self = .subjectKeyID
//        default:
//            return nil
//        }
//    }
//
//    public var rawValue: String {
//        switch self {
//        case .certificateEncoding:
//            return String(kSecAttrCertificateEncoding)
//        case .certificateType:
//            return String(kSecAttrCertificateType)
//        case .issuer:
//            return String(kSecAttrIssuer)
//        case .publicKeyHash:
//            return String(kSecAttrPublicKeyHash)
//        case .serialNumber:
//            return String(kSecAttrSerialNumber)
//        case .subject:
//            return String(kSecAttrSubject)
//        case .subjectKeyID:
//            return String(kSecAttrSubjectKeyID)
//        }
//    }
// }
