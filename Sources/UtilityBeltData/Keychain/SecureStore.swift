// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import Security

// swiftlint:disable missing_docs

public struct SecureStore {
    let secureStoreQueryable: SecureStoreQueryable

    public init(secureStoreQueryable: SecureStoreQueryable) {
        self.secureStoreQueryable = secureStoreQueryable
    }
    
    public func setValue(_ value: String, for userAccount: String) throws {
        // Check if it can encode the value to store into a Data type. If that’s not possible, it throws a conversion error.
        guard let encodedPassword = value.data(using: .utf8) else {
            throw SecureStoreError.string2DataConversionError
        }
        
        // Ask the secureStoreQueryable instance for the query to execute and append the account you’re looking for.
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount
        
        // Return the keychain item that matches the query.
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        switch status {
        // If the query succeeds, it means a password for that account already exists.
        // In this case, you replace the existing password’s value using SecItemUpdate(_:_:).
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = encodedPassword
            
            status = SecItemUpdate(query as CFDictionary,
                                   attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                throw error(from: status)
            }
        // If it cannot find an item, the password for that account does not exist yet. You add the item by invoking SecItemAdd(_:_:).
        case errSecItemNotFound:
            query[String(kSecValueData)] = encodedPassword
            
            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                throw error(from: status)
            }
        default:
            throw error(from: status)
        }
    }
    
    public func getValue(for userAccount: String) throws -> String? {
        // Ask secureStoreQueryable for the query to execute. Besides adding the account you’re interested in,
        // this enriches the query with other attributes and their related values. In particular,
        // you’re asking it to return a single result, to return all the attributes associated with that
        // specific item and to give you back the unencrypted data as a result.
        var query = secureStoreQueryable.query
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        query[String(kSecAttrAccount)] = userAccount
        
        // Use SecItemCopyMatching(_:_:) to perform the search. On completion,
        // queryResult will contain a reference to the found item, if available.
        // withUnsafeMutablePointer(to:_:) gives you access to an UnsafeMutablePointer
        // that you can use and modify inside the closure to store the result.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, $0)
        }
        
        switch status {
        // If the query succeeds, it means that it found an item. Since the result is represented
        // by a dictionary that contains all the attributes you’ve asked for,
        // you need to extract the data first and then decode it into a Data type.
        case errSecSuccess:
            guard
                let queriedItem = queryResult as? [String: Any],
                let passwordData = queriedItem[String(kSecValueData)] as? Data,
                let password = String(data: passwordData, encoding: .utf8)
                else {
                    throw SecureStoreError.data2StringConversionError
            }
            return password
        // If an item is not found, return a nil value.
        case errSecItemNotFound:
            return nil
        default:
            throw error(from: status)
        }
    }
    
    public func removeValue(for userAccount: String) throws {
        var query = secureStoreQueryable.query
        query[String(kSecAttrAccount)] = userAccount
        
        // To remove a password, you perform SecItemDelete(_:) specifying the account you’re looking for.
        // If you successfully deleted the password or if no item was found, your job is done and you bail out.
        // Otherwise, you throw an unhandled error in order to let the user know something went wrong.
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw error(from: status)
        }
    }
    
    /// Removes all values from the Keychain.
    public func removeAllValues() throws {
        let query = secureStoreQueryable.query
        
        let status = SecItemDelete(query as CFDictionary)
        
        // If the status is anything other than not found or success, throw associated error
        switch status {
        case errSecItemNotFound,
             errSecSuccess:
            return
        default:
            throw self.error(from: status)
        }
    }

    private func error(from status: OSStatus) -> SecureStoreError {
        let message: String

        if #available(iOS 11.3, *) {
            message = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        } else {
            // Unfortunately, we most likely can't get anything meaningful out of the OSStatus here
            // We can look up the code on https://osstatus.com, but even that resource has an incomplete mapping of OS errors
            let error = NSError(domain: NSOSStatusErrorDomain, code: Int(status), userInfo: nil)
            message = error.localizedDescription
        }

        return SecureStoreError.unhandledError(message: message)
    }
}
