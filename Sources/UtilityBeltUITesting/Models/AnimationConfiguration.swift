// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

/// Struct to convey how the main target should handle animations.
public struct AnimationConfiguration: LaunchEnvironmentCodable {
    /// The key used to save and retrieve the object in the launch environment.
    public static var launchEnvironmentKey = "animation-configuration"
    
    /// Whether or not animations are enabled.
    public var animationsEnabled: Bool
    
    /// The value with which to set the application's key window layer speed.
    /// See Apple's [documentation](https://developer.apple.com/documentation/quartzcore/camediatiming/1427647-speed) for more information.
    public var layerAnimationSpeed: Float
    
    public init(animationsEnabled: Bool, layerAnimationSpeed: Float = 1.0) {
        self.animationsEnabled = animationsEnabled
        self.layerAnimationSpeed = layerAnimationSpeed
    }
}
