// Copyright © 2021 SpotHero, Inc. All rights reserved.

#if canImport(XCTest)

    import UtilityBeltUITesting
    import XCTest

    public extension XCUIApplication {
        /// Convenience method for merging new launch arguments into the launch arguments array.
        /// - Parameter objects: An array of launch argument objects that will be adding into the launch arguments.
        func appendLaunchArguments(_ arguments: [LaunchArgument]) {
            arguments.forEach { argument in
                switch argument {
                case let .custom(value):
                    self.launchArguments += [value]
                }
            }
        }
    }

#endif
