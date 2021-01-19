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
                case .custom:
                    self.launchArguments += [argument.formattedKey]
                case let .userDefault(_, value),
                     let .argument(_, value):
                    self.launchArguments += [argument.formattedKey, value]
                }
            }
        }
    }

#endif
