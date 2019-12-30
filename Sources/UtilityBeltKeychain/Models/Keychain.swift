// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// A wrapper around Keychain Item configuration to simplify usage.
public final class Keychain {
    // MARK: - Properties

    private let configuration: KeychainConfiguration
    
    // MARK: - Methods

    // MARK: Initializers

    /// Initializes a Generic Password Keychain.
    /// - Parameters:
    ///   - service: The service associated with this item.
    ///   - accessGroup: The access group associated with this item.
    public init(service: String, accessGroup: String? = nil) {
        self.configuration = GenericPasswordKeychainConfiguration(service: service, accessGroup: accessGroup)
    }

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
                accessGroup: String? = nil) {
        self.configuration = InternetPasswordKeychainConfiguration(server: server,
                                                                   protocol: `protocol`,
                                                                   authenticationType: authenticationType,
                                                                   path: path,
                                                                   port: port,
                                                                   securityDomain: securityDomain,
                                                                   accessGroup: accessGroup)
    }

    // MARK: Key Access

    /// Sets a String value for a given account in the keychain.
    /// - Parameters:
    ///   - value: The data to set in the keychain.
    ///   - account: The account to set the data for.
    public func setValue(_ value: String, for account: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw UBKeychainError.couldNotConvertDataToString
        }

        try self.setValue(data, for: account)
    }

    /// Sets a Data value for a given account in the keychain.
    /// - Parameters:
    ///   - value: The data to set in the keychain.
    ///   - account: The account to set the data for.
    public func setValue(_ data: Data, for account: String) throws {
        // Ask the secureStoreQueryable instance for the query to execute and append the account you’re looking for.
        var query = self.configuration.asDictionary()
        query[.account] = account

        // Return the keychain item that matches the query.
        var status = SecItemCopyMatching(query.asKeychainQuery(), nil)
        switch status {
        // If the query succeeds, it means a password for that account already exists.
        // In this case, you replace the existing password’s value using SecItemUpdate(_:_:).
        case errSecSuccess:
            var attributesToUpdate: KeychainDictionary = [:]
            attributesToUpdate[.data] = data

            status = SecItemUpdate(query.asKeychainQuery(),
                                   attributesToUpdate.asKeychainQuery())
            if status != errSecSuccess {
                throw self.error(from: status)
            }
        // If it cannot find an item, the password for that account does not exist yet. You add the item by invoking SecItemAdd(_:_:).
        case errSecItemNotFound:
            query[.data] = data

            status = SecItemAdd(query.asKeychainQuery(), nil)
            if status != errSecSuccess {
                throw self.error(from: status)
            }
        default:
            throw self.error(from: status)
        }
    }

    /// Gets a Data value for a given account in the keychain.
    /// - Parameter account: The account to get the value from.
    public func getValue(for account: String) throws -> Data? {
        // Ask secureStoreQueryable for the query to execute. Besides adding the account you’re interested in,
        // this enriches the query with other attributes and their related values. In particular,
        // you’re asking it to return a single result, to return all the attributes associated with that
        // specific item and to give you back the unencrypted data as a result.
        var query = self.configuration.asDictionary()
        query[.matchLimit] = kSecMatchLimitOne
        query[.returnAttributes] = true
        query[.returnData] = true
        query[.account] = account
        
        // Use SecItemCopyMatching(_:_:) to perform the search. On completion,
        // queryResult will contain a reference to the found item, if available.
        // withUnsafeMutablePointer(to:_:) gives you access to an UnsafeMutablePointer
        // that you can use and modify inside the closure to store the result.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query.asKeychainQuery(), $0)
        }
        
        switch status {
            // If the query succeeds, it means that it found an item. Since the result is represented
            // by a dictionary that contains all the attributes you’ve asked for,
        // you need to extract the data first and then decode it into a Data type.
        case errSecSuccess:
            let queriedItem = queryResult as? [String: Any]
            return queriedItem?[KeychainAttribute.data.rawValue] as? Data
        // If an item is not found, return a nil value.
        case errSecItemNotFound:
            return nil
        default:
            throw self.error(from: status)
        }
    }

    /// Removes a value for a given account in the keychain.
    /// - Parameter account: The account to remove the value from.
    public func removeValue(for account: String) throws {
        var query = self.configuration.asDictionary()
        query[.account] = account

        // To remove a password, you perform SecItemDelete(_:) specifying the account you’re looking for.
        // If you successfully deleted the password or if no item was found, your job is done and you bail out.
        // Otherwise, you throw an unhandled error in order to let the user know something went wrong.
        let status = SecItemDelete(query.asKeychainQuery())

        // If the status is anything other than success or not found, throw associated error
        switch status {
        case errSecSuccess,
             errSecItemNotFound:
            return
        default:
            throw self.error(from: status)
        }
    }

    /// Removes all values from the Keychain.
    public func removeAllValues() throws {
        let query = self.configuration.asDictionary()
        let status = SecItemDelete(query.asKeychainQuery())

        // If the status is anything other than success or not found, throw associated error
        switch status {
        case errSecSuccess,
             errSecItemNotFound:
            return
        default:
            throw self.error(from: status)
        }
    }
    
    private func error(from status: OSStatus) -> UBKeychainError {
        let message: String

        if #available(iOS 11.3, *) {
            message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        } else {
            // Unfortunately, we most likely can't get anything meaningful out of the OSStatus here
            // We can look up the code on https://osstatus.com, but even that resource has an incomplete mapping of OS errors
            let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
            message = error.localizedDescription
        }

        return UBKeychainError.unhandled(message: message)
    }
}
