// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

typealias KeychainDictionary = [KeychainAttribute: Any?]

extension KeychainDictionary {
    /// Converts the dictionary into a Keychain query-compatible CFDictionary.
    func asKeychainQuery() -> CFDictionary {
        // Reduce the KeychainDictionary into a [AnyHashable: Any] dictionary,
        // converting enum keys into their raw string values and ignoring all nil values.
        let stringKeyedDictionary = self.reduce(into: [:]) { result, currentItem in
            if let value = currentItem.value {
                result[currentItem.key.rawValue] = value
            }
        }
        
        // Return the string keyed dictionary, converted into a CFDictionary
        return stringKeyedDictionary as CFDictionary
    }
}
