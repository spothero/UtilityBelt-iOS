// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public extension UserDefaultsConfiguration {
    /// Injects the configuration into the appropriate `UserDefaults`.
    func injectIntoUserDefaults() {
        for object in self.standard {
            self.storeObject(object, in: UserDefaults.standard)
        }
        
        for (suiteName, objects) in self.customSuites {
            guard let defaults = UserDefaults(suiteName: suiteName) else {
                continue
            }
            
            for object in objects {
                self.storeObject(object, in: defaults)
            }
        }
    }
    
    private func storeObject(_ object: UserDefaultsObject, in userDefaults: UserDefaults) {
        switch object.value {
        case let .bool(value):
            userDefaults.setValue(value, forKey: object.key)
        case let .data(value):
            userDefaults.setValue(value, forKey: object.key)
        case let .date(value):
            userDefaults.setValue(value, forKey: object.key)
        case let .int(value):
            userDefaults.setValue(value, forKey: object.key)
        case let .string(value):
            userDefaults.setValue(value, forKey: object.key)
        }
    }
}
