// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
import Sham

public extension MockService {
    /// Sets up the mock service object using launch environment mocked data information.
    static func setupWithLaunchEnvironment() {
        // Find and decode the launch environment stubbed data collection.
        guard
            let mockDataObjectString = ProcessInfo.processInfo.environment[StubbedDataCollection.launchEnvironmentKey],
            let mockDataObjectData = mockDataObjectString.data(using: .utf8),
            let stubbedDataCollection = try? JSONDecoder().decode(StubbedDataCollection.self, from: mockDataObjectData) else {
            return
        }
        
        MockService.shared.stubbedDataCollection = stubbedDataCollection
    }
}
