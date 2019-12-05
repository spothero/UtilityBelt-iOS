// Copyright © 2019 SpotHero, Inc. All rights reserved.

//// Copyright © 2019 SpotHero, Inc. All rights reserved.
//
// import Foundation
//
///// Represents a Generic Password Keychain Item.
/////
///// [Source](https://developer.apple.com/documentation/security/ksecclasscertificate)
// public final class CertificateKeychainItem: KeychainItem {
//    // MARK: - Properties
//
//    /// Denotes the certificate encoding (see the CSSM_CERT_ENCODING enumeration in cssmtype.h).
//    /// Read only.
//    ///
//    /// The attribute key for this property is `kSecAttrCertificateEncoding`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrcertificateencoding)
//    public internal(set) var certificateEncoding: Int?
//
//    /// Denotes the certificate type (see the CSSM_CERT_TYPE enumeration in cssmtype.h).
//    /// Read only.
//    ///
//    /// The attribute key for this property is `kSecAttrCertificateType`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrcertificatetype)
//    public internal(set) var certificateType: Int?
//
//    /// Contains the X.500 issuer name of a certificate.
//    /// Read only.
//    ///
//    /// The attribute key for this property is `kSecAttrIssuer`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrissuer)
//    public internal(set) var issuer: Data?
//
//    /// Contains the hash of a certificate's public key.
//    /// Read only.
//    ///
//    /// The attribute key for this property is `kSecAttrPublicKeyHash`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrpublickeyhash)
//    public internal(set) var publicKeyHash: Data?
//
//    /// Contains the serial number data of a certificate.
//    /// Read only.
//    ///
//    /// The attribute key for this property is `kSecAttrSerialNumber`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrserialnumber)
//    public internal(set) var serialNumber: Data?
//
//    /// Contains the X.500 subject name of a certificate.
//    /// Read only.
//    ///
//    /// The attribute key for this property is `kSecAttrSubject`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrsubject)
//    public internal(set) var subject: Data?
//
//    /// Contains the subject key ID of a certificate.
//    /// Read only.
//    ///
//    /// The attribute key for this property is `kSecAttrSubjectKeyID`.
//    ///
//    /// [Source](https://developer.apple.com/documentation/security/ksecattrsubjectkeyid)
//    public internal(set) var subjectKeyID: Data?
//
//    // MARK: - Methods
//
//    // MARK: Initializers
//
//    override public init() {
//        super.init()
//    }
// }
