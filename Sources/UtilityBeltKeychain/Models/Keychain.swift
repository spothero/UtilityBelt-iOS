// Copyright © 2020 SpotHero, Inc. All rights reserved.

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
    
    /// Stores a String value for a given account in the keychain.
    /// - Parameters:
    ///   - value: The data to set in the keychain.
    ///   - account: The account to set the data for.
    public func setValue(_ value: String, for account: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw UBKeychainError.couldNotConvertStringToData
        }
        
        try self.setValue(data, for: account)
    }
    
    /// Stores a Data value for a given account in the keychain.
    /// - Parameters:
    ///   - value: The data to set in the keychain.
    ///   - account: The account to set the data for.
    public func setValue(_ data: Data, for account: String) throws {
        // Get the query from the KeychainConfiguration as a dictionary
        var query = self.configuration.asDictionary()
        query[.account] = account
        
        // Fetch the keychain item that matches the query
        let matchStatus = SecItemCopyMatching(query.asKeychainQuery(), nil)
        
        switch matchStatus {
        case errSecSuccess:
            // If a matching keychain item is found, replace the item
            var keychainAttributes: KeychainDictionary = [:]
            keychainAttributes[.data] = data
            
            let updateStatus = SecItemUpdate(query.asKeychainQuery(), keychainAttributes.asKeychainQuery())
            
            if updateStatus != errSecSuccess {
                throw self.error(from: updateStatus)
            }
        case errSecItemNotFound:
            // If a matching keychain item is not found, add the item
            query[.data] = data
            
            let addStatus = SecItemAdd(query.asKeychainQuery(), nil)
            
            // If the operation to add a keychain item is unsuccessful, throw an error
            if addStatus != errSecSuccess {
                throw self.error(from: addStatus)
            }
        default:
            throw self.error(from: matchStatus)
        }
    }
    
    /// Retrieves a Data value for a given account in the keychain.
    /// - Parameter account: The account to get the value from.
    public func getValue(for account: String) throws -> Data? {
        // Get the query from the KeychainConfiguration as a dictionary
        var query = self.configuration.asDictionary()
        query[.account] = account
        
        // Set the match limit to 1 result
        query[.matchLimit] = kSecMatchLimitOne
        
        // Tell the query we want to return attributes and data for the item
        query[.returnAttributes] = true
        query[.returnData] = true
        
        // Will contain a reference to the matching item if found
        var queryResult: AnyObject?
        
        let matchStatus = withUnsafeMutablePointer(to: &queryResult) {
            // Fetch the keychain item that matches the query
            SecItemCopyMatching(query.asKeychainQuery(), $0)
        }
        
        switch matchStatus {
        case errSecSuccess:
            // If a matching keychain item is found, return the item's data
            let queriedItem = queryResult as? [String: Any]
            return queriedItem?[KeychainAttribute.data.rawValue] as? Data
        case errSecItemNotFound:
            // If a matchig keychain item is not found, return nil
            return nil
        default:
            throw self.error(from: matchStatus)
        }
    }
    
    /// Removes a value for a given account in the keychain.
    /// - Parameter account: The account to remove the value from.
    public func removeValue(for account: String) throws {
        // Get the query from the KeychainConfiguration as a dictionary
        var query = self.configuration.asDictionary()
        query[.account] = account
        
        // Attempt to delete the keychain item that matches the query
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
        // Get the query from the KeychainConfiguration as a dictionary
        let query = self.configuration.asDictionary()
        
        // Attempt to delete all keychain items for this configuration
        let deleteStatus = SecItemDelete(query.asKeychainQuery())
        
        // If the status is anything other than success or not found, throw associated error
        switch deleteStatus {
        case errSecSuccess,
             errSecItemNotFound:
            return
        default:
            throw self.error(from: deleteStatus)
        }
    }
    
    private func error(from status: OSStatus) -> UBKeychainError {
        let message: String
        
        if #available(iOS 11.3, tvOS 11.3, watchOS 4.3, *) {
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
