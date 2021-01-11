// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public final class UserDefaultsConfiguration: LaunchEnvironmentCodable {
    // MARK: Properties
    
    /// A dictionary represent key/value pairs to be written to the `.standard` UserDefaults.
    public private(set) var standardDictionary: [String: Any] = [:]
    
    /// A dictionary represent key/value pairs to be written to UserDefaults where the
    /// top-level key is the name of the suite, and the value is a dictionary of UserDefaults.
    public private(set) var customSuitesDictionary: [String: [String: Any]] = [:]
    
    // MARK: Storing UserDefaults
    
    /// Stores a value for the given key in the standard UserDefaults dictionary.
    public func storeValue(_ value: Any, forKey key: String) {
        self.standardDictionary[key] = value
    }
    
    /// Stores a value for the given key in a dictionary under the given suite name.
    public func storeValue(_ value: Any, forKey key: String: inSuite suite: String) {
        if self.customSuitesDictionary[suite] == nil {
            self.customSuitesDictionary[suite] = [:]
        }
        
        self.customSuitesDictionary[suite]?[key] = value
    }
}
