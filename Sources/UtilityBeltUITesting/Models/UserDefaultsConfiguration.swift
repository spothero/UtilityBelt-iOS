// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public final class UserDefaultsConfiguration: LaunchEnvironmentCodable {
    // MARK: CodingKeys
    
    private enum CodingKeys: CodingKey {
        case standardDictionaryData
        case customSuitesDictionaryData
    }
    
    // MARK: Properties
    
    public static let launchEnvironmentKey = "user-defaults-configuration"
    
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
    public func storeValue(_ value: Any, forKey key: String, inSuite suite: String) {
        if self.customSuitesDictionary[suite] == nil {
            self.customSuitesDictionary[suite] = [:]
        }
        
        self.customSuitesDictionary[suite]?[key] = value
    }
   
    // MARK: Decodable
    
    public init() {}
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let standardDictionaryData = try container.decode(Data.self,
                                                          forKey: .standardDictionaryData)
        self.standardDictionary = try JSONSerialization
            .jsonObject(with: standardDictionaryData, options: []) as? [String: Any] ?? [:]
        
        let customSuitesDictionaryData = try container.decode(Data.self,
                                                              forKey: .customSuitesDictionaryData)
        self.customSuitesDictionary = try JSONSerialization
            .jsonObject(with: customSuitesDictionaryData, options: []) as? [String: [String: Any]] ?? [:]
    }
    
    // MARK: Encodable
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let standardDictionaryData = try JSONSerialization.data(withJSONObject: self.standardDictionary,
                                                                options: [])
        try container.encode(standardDictionaryData, forKey: .standardDictionaryData)
        
        let customSuitesDictionaryData = try JSONSerialization.data(withJSONObject: self.customSuitesDictionary,
                                                                    options: [])
        try container.encode(customSuitesDictionaryData, forKey: .customSuitesDictionaryData)
    }
}
