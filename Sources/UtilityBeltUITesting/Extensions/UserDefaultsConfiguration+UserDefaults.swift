// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public extension UserDefaultsConfiguration {
    /// Injects the configuration into the appropriate `UserDefaults`.
    func injectIntoUserDefaults() {
        for object in self.standard {
            UserDefaults.standard.setValue(object.value, forKey: object.key)
        }
        
        for (suiteName, objects) in self.customSuites {
            let defaults = UserDefaults(suiteName: suiteName)
            for object in objects {
                defaults?.setValue(object.value, forKey: object.key)
            }
        }
    }
}
