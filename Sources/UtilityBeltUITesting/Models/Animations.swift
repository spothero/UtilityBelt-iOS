// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

/// Struct to convey whether the target should enable or disable animations.
public struct Animations: LaunchEnvironmentCodable {
    /// The key used to save and retrieve the object in the launch environment.
    public static var launchEnvironmentKey = "animations"
    
    /// Whether or not animations are enabled.
    public var animationsEnabled: Bool
    
    public init(enabled: Bool) {
        self.animationsEnabled = enabled
    }
}
