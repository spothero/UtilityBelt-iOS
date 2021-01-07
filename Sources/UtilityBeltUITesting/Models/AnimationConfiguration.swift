// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

/// Struct to convey how the main target should handle animations.
public struct AnimationConfiguration: LaunchEnvironmentCodable {
    /// The key used to save and retrieve the object in the launch environment.
    public static var launchEnvironmentKey = "animation-configuration"
    
    /// Whether or not animations are enabled.
    public var animationsEnabled: Bool
    
    public init(animationsEnabled: Bool) {
        self.animationsEnabled = animationsEnabled
    }
}
