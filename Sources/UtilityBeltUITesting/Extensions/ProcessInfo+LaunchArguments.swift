// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public extension ProcessInfo {
    /// Determines whether or not the arguments for the process contain the specific launch argument.
    /// - Parameter argument: The argument in question.
    /// - Returns: Whether or not the arguments for the process contain the specific launch argument.
    static func containsLaunchArgument(_ argument: LaunchArgument) -> Bool {
        switch argument {
        case let .custom(value):
            return self.processInfo.arguments.contains(value)
        }
    }
}
