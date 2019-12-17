// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

typealias KeychainDictionary = [KeychainAttribute: Any?]

extension Dictionary where Key == KeychainAttribute, Value == Any? {
    /// Convert the key from enum into raw string values and removes all nil values.
    func asKeychainQuery() -> CFDictionary {
        var stringKeyedDictionary = [String: Any]()

        for (key, value) in self {
            guard var value = value else {
                continue
            }

            stringKeyedDictionary[key.rawValue] = value
        }

        return stringKeyedDictionary as CFDictionary
    }
}
