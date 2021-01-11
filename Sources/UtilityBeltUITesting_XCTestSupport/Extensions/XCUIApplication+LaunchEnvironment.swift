// Copyright © 2021 SpotHero, Inc. All rights reserved.

#if canImport(XCTest)

    import UtilityBeltUITesting
    import XCTest

    public extension XCUIApplication {
        /// Convenience method for setting up the launch environment with specific information and launching the application.
        /// - Parameter objects: An array of launch environment encodable objects that will be encoded into the launch environment.
        /// - Throws: Will throw an error if an object is unable to be encoded into the launch environment.
        func launch(withEnvironmentObjects objects: [LaunchEnvironmentCodable]) throws {
            try objects.forEach { object in
                let environmentKey = type(of: object).launchEnvironmentKey
                // TODO: https://spothero.atlassian.net/browse/IOS-2690
                // Handle collisions instead of overriding previous values.
                self.launchEnvironment[environmentKey] = try object.encodedAsString()
            }
            self.launch()
        }
    }

#endif