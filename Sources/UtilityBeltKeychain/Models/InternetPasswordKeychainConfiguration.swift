// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents an Internet Password Keychain.
///
/// [Source](https://developer.apple.com/documentation/security/ksecclassinternetpassword)
final class InternetPasswordKeychainConfiguration: KeychainConfiguration {
    // MARK: - Properties
    
    /// The authentication scheme.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrAuthenticationType`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrauthenticationtype)
    let authenticationType: KeychainAuthenticationType?
    
    /// Represents a path, typically the path component of the URL.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrPath`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrpath)
    let path: String?
    
    /// The Internet port number.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrPort`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrport)
    let port: Int?
    
    /// The internet protocol.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrProtocol`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrprotocol)
    let `protocol`: KeychainInternetProtocol?
    
    /// The Internet security domain.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrSecurityDomain`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrsecuritydomain)
    let securityDomain: String?
    
    /// The server's domain name or IP address.
    /// Required.
    ///
    /// The attribute key for this property is `kSecAttrServer`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrserver)
    let server: String
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    init(server: String,
         protocol: KeychainInternetProtocol = .https,
         authenticationType: KeychainAuthenticationType = .default,
         path: String? = nil,
         port: Int? = nil,
         securityDomain: String? = nil,
         accessGroup: String? = nil) {
        self.server = server
        self.protocol = `protocol`
        self.authenticationType = authenticationType
        self.path = path
        self.port = port
        self.securityDomain = securityDomain
        
        super.init(class: .internetPassword, accessGroup: accessGroup)
    }
    
    // MARK: Converters
    
    override func asDictionary() -> [KeychainAttribute: Any?] {
        var query = super.asDictionary()
        
        query[.authenticationType] = self.authenticationType?.rawValue
        query[.path] = self.path
        query[.port] = self.port
        query[.protocol] = self.protocol?.rawValue
        query[.securityDomain] = self.securityDomain
        query[.server] = self.server
        
        return query
    }
}
