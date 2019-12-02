// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// Represents a Generic Password Keychain Item.
///
/// [Source](https://developer.apple.com/documentation/security/ksecclassinternetpassword)
public final class InternetPasswordKeychainItem: PasswordKeychainItem {
    // MARK: - Properties

    /// The authentication scheme.
    ///
    /// The attribute key for this property is `kSecAttrAuthenticationType`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrauthenticationtype)
    public var authenticationType: Int?

    /// Represents a path, typically the path component of the URL.
    ///
    /// The attribute key for this property is `kSecAttrPath`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrpath)
    public var path: String?

    /// The Internet port number.
    ///
    /// The attribute key for this property is `kSecAttrPort`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrport)
    public var port: Int?

    /// The internet protocol.
    ///
    /// The attribute key for this property is `kSecAttrProtocol`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrprotocol)
    public var `protocol`: Int?

    /// The Internet security domain.
    ///
    /// The attribute key for this property is `kSecAttrSecurityDomain`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrsecuritydomain)
    public var securityDomain: String?

    /// The server's domain name or IP address.
    ///
    /// The attribute key for this property is `kSecAttrServer`.
    ///
    /// [Source](https://developer.apple.com/documentation/security/ksecattrserver)
    public var server: String?

    // MARK: - Methods

    // MARK: Initializers

    override public init() {
        super.init()
    }
}
