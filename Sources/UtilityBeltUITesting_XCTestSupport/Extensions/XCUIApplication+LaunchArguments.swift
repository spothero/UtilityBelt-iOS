// Copyright © 2021 SpotHero, Inc. All rights reserved.

#if canImport(XCTest)

    import UtilityBeltUITesting
    import XCTest

    public extension XCUIApplication {
        /// Convenience method for merging new launch arguments into the launch arguments array.
        /// - Parameter objects: An array of launch argument objects that will be adding into the launch arguments.
        func updateLaunchArguments(_ arguments: [LaunchArgument]) {
            self.launchArguments += arguments.map(\.rawValue).filter { !self.launchArguments.contains($0) }
        }
    }

#endif
