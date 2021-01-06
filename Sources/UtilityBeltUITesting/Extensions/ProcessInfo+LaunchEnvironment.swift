// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public extension ProcessInfo {
    /// Fetches and decodes a launch environment object based on the input class.
    /// - Parameter type: The type of class to fetch.
    /// - Returns: The fetched object, if it exists. Otherwise returns nil.
    static func fetchFromLaunchEnvironment<T: LaunchEnvironmentCodable>(withType type: T.Type) -> T? {
        // Find and decode the launch environment object.
        guard
            let objectString = self.processInfo.environment[type.launchEnvironmentKey],
            let objectData = objectString.data(using: .utf8),
            let object = try? JSONDecoder().decode(type, from: objectData) else {
            return nil
        }
        return object
    }
}
