// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

internal typealias KeychainDictionary = [KeychainAttribute: Any?]

internal extension Dictionary where Key == KeychainAttribute, Value == Any? {
    /// Convert the key from enum into raw string values.
    /// Also removes all nil values and converts other values as needed, such as Bool to CFBoolean.
    func asKeychainQuery() -> CFDictionary {
        var stringKeyedDictionary = [String: Any]()
        
        for (key, value) in self {
            guard var value = value else {
                continue
            }
            
            if let keychainConvertible = value as? KeychainValueConvertible {
                value = keychainConvertible.keychainValue
            }

            stringKeyedDictionary[key.rawValue] = value
            
        }
        
        return stringKeyedDictionary as CFDictionary
    }
}
