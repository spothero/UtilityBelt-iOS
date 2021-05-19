// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public final class UUIDConfiguration: LaunchEnvironmentCodable {
    // MARK: Properties
    
    public static let launchEnvironmentKey = "user-uuid-configuration"
    
    /// An array representing source/value pairs to be written to the UUID factory.
    public private(set) var values: [UUIDConfigurationObject] = []
   
    // MARK: Initialization
    
    public init() {}
    
    // MARK: Storing UUID Configuration
    
    /// Stores the `UUIDConfigurationObject` in the `UUIDConfiguration`.
    public func storeUUIDConfigurationObject(_ object: UUIDConfigurationObject) {
        self.values.removeAll(where: { $0.source == object.source })
        self.values.append(object)
    }
}
