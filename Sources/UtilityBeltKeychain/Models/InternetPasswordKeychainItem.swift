// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents a Generic Password Keychain Item.
///
/// [Source](https://developer.apple.com/documentation/security/ksecclassinternetpassword)
public final class InternetPasswordKeychainItem: PasswordKeychainItem {
    // MARK: - Properties

    /// The authentication scheme.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrAuthenticationType`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrauthenticationtype)
    public var authenticationType: KeychainAuthenticationType?

    /// Represents a path, typically the path component of the URL.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrPath`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrpath)
    public var path: String?

    /// The Internet port number.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrPort`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrport)
    public var port: Int?

    /// The internet protocol.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrProtocol`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrprotocol)
    public var `protocol`: KeychainInternetProtocol?

    /// The Internet security domain.
    /// Optional.
    ///
    /// The attribute key for this property is `kSecAttrSecurityDomain`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrsecuritydomain)
    public var securityDomain: String?

    /// The server's domain name or IP address.
    /// Required.
    ///
    /// The attribute key for this property is `kSecAttrServer`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrserver)
    public var server: String

    // MARK: - Methods

    // MARK: Initializers

    public init(server: String, account: String, data: Data, accessGroup: String? = nil) {
        self.server = server
        
        super.init(class: .internetPassword, account: account, data: data, accessGroup: accessGroup)
    }
    
    // MARK: Converters
    
    override internal func asDictionary() -> [KeychainAttribute: Any?] {
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
