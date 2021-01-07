// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation
import Sham

public extension MockService {
    /// Sets up the mock service object using launch environment mocked data information.
    static func setupWithLaunchEnvironment() {
        // Find and decode the launch environment stubbed data collection.
        guard let stubbedDataCollection = ProcessInfo.fetchFromLaunchEnvironment(withType: StubbedDataCollection.self) else {
            return
        }
        MockService.shared.updateStubbedData(withCollection: stubbedDataCollection)
    }
}
