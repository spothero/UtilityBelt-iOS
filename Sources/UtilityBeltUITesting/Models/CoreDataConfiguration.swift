// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

/// Struct that provides information that the main target should use to configure Core Data.
public struct CoreDataConfiguration: LaunchEnvironmentCodable {
    // MARK: Properties
    
    public static let launchEnvironmentKey = "core-data-configuration"
    
    /// The URL of the Core Data database to use.
    public let databaseURL: URL
    
    // MARK: Initialization
    
    public init(databaseURL: URL) {
        self.databaseURL = databaseURL
    }
}
