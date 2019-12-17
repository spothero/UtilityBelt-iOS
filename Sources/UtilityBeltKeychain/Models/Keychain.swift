// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// A wrapper around Keychain Item configuration to simplify usage.
public final class Keychain {
    // MARK: - Methods

    // MARK: Initializers

    /// Initializes a Generic Password Keychain.
    /// - Parameters:
    ///   - service: The service associated with this item.
    ///   - accessGroup: The access group associated with this item.
    public init(service: String, accessGroup: String? = nil) {}

    /// Initializes an Internet Password Keychain.
    /// - Parameters:
    ///   - server: The domain name or IP address associated with this item.
    ///   - protocol: The internet protocol associated with this item.
    ///   - authenticationType: The authentication type associated with this item.
    ///   - path: The path component of the URL associated with this item.
    ///   - port: The port number associated with this item.
    ///   - securityDomain: The security domain associated with this item.
    ///   - accessGroup: The access group associated with this item.
    public init(server: String,
                protocol: KeychainInternetProtocol = .https,
                authenticationType: KeychainAuthenticationType = .default,
                path: String? = nil,
                port: Int? = nil,
                securityDomain: String? = nil,
                accessGroup: String? = nil) {}

    // MARK: Key Access

    /// Sets a String value for a given account in the keychain.
    /// - Parameters:
    ///   - value: The data to set in the keychain.
    ///   - account: The account to set the data for.
    public func setValue(_ value: String, for account: String) throws {}

    /// Sets a Data value for a given account in the keychain.
    /// - Parameters:
    ///   - value: The data to set in the keychain.
    ///   - account: The account to set the data for.
    public func setValue(_ value: Data, for account: String) throws {}

    /// Gets a Data value for a given account in the keychain.
    /// - Parameter account: The account to get the value from.
    public func getValue(for account: String) throws -> Data? {
        return nil
    }

    /// Removes a value for a given account in the keychain.
    /// - Parameter account: The account to remove the value from.
    public func removeValue(for account: String) throws {}

    /// Removes all values from the Keychain.
    public func removeAllValues() throws {}
}
