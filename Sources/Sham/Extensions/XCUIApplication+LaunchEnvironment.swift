// Copyright © 2020 SpotHero, Inc. All rights reserved.

#if canImport(XCTest)

    import XCTest

    public extension XCUIApplication {
        /// Convenience method for setting up the launch environment with specific information and launching the application.
        /// - Parameter objects: An array of launch environment objects that will be encoded into the launch environment.
        /// - Throws: Will throw an error if an object is unable to be encoded into the launch environment.
        func launch(withEnvironmentObjects objects: [LaunchEnvironmentObject]) throws {
            try objects.forEach { object in
                let environmentKey = type(of: object).launchEnvironmentKey
                self.launchEnvironment[environmentKey] = try object.encodedStringValue()
            }
            self.launch()
        }
    }

#endif
