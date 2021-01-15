// Copyright © 2021 SpotHero, Inc. All rights reserved.

#if canImport(XCTest)

    import UtilityBeltUITesting
    import XCTest

    public extension XCUIApplication {
        /// Convenience method for merging new launch arguments into the launch arguments array.
        /// - Parameter objects: An array of launch argument objects that will be adding into the launch arguments.
        func updateLaunchArguments(_ arguments: [LaunchArgument]) {
            arguments.forEach { argument in
                // Remove the argument in the case that it already exists.
                self.removeLaunchArgument(argument)
                self.launchArguments += [argument.rawValue]
            }
        }
        
        /// Remove an argument from the launch arguments, if it exists.
        /// - Parameter argument: The argument to remove.
        func removeLaunchArgument(_ argument: LaunchArgument) {
            self.launchArguments.removeAll(where: { existingValue in
                existingValue == argument.rawValue
            })
        }
    }

#endif
