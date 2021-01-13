// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public final class UserDefaultsConfiguration: LaunchEnvironmentCodable {
    // MARK: Properties
    
    public static let launchEnvironmentKey = "user-defaults-configuration"
    
    /// An array representing key/value pairs to be written to the `.standard` UserDefaults.
    public private(set) var standard: [UserDefaultsObject] = []
    
    /// A dictionary representing key/value pairs to be written to UserDefaults where the
    /// top-level key is the name of the suite, and the value is a dictionary of UserDefaults.
    public private(set) var customSuites: [String: [UserDefaultsObject]] = [:]
    
    // MARK: Storing UserDefaults
    
    /// Stores the `UserDefaultsObject` for use in `UserDefaults.standard`.
    public func storeUserDefaultsObject(_ object: UserDefaultsObject) {
        self.standard.removeAll(where: { $0.key == object.key })
        self.standard.append(object)
    }

    /// Stores a value `UserDefaultsObject` in an array under the given suite name.
    public func storeUserDefaultsObject(_ object: UserDefaultsObject, inSuite suite: String) {
        if self.customSuites[suite] == nil {
            self.customSuites[suite] = []
        }

        self.customSuites[suite]?.removeAll(where: { $0.key == object.key })

        self.customSuites[suite]?.append(object)
    }
   
    // MARK: Initialization
    
    public init() {}
}
