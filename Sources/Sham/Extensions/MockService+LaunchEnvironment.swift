// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public extension MockService {
    /// Sets up the mock service object using launch environment mocked data information.
    func setupWithLaunchEnvironment() {
        // Find and decode the launch environment mocked data.
        guard
            let mockDataObjectString = ProcessInfo.processInfo.environment[LaunchEnvironmentMockData.launchEnvironmentKey],
            let mockDataObjectData = mockDataObjectString.data(using: .utf8),
            let mockDataObject = try? JSONDecoder().decode(LaunchEnvironmentMockData.self, from: mockDataObjectData) else {
            return
        }
        
        // Populate the mock service with the stubbed data.
        mockDataObject.stubbedData.forEach { key, value in
            self.stub(key, with: value)
        }
    }
}
