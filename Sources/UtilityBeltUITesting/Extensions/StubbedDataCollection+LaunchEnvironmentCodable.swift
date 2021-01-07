// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation
import Sham

extension StubbedDataCollection: LaunchEnvironmentCodable {
    /// The key used to save and retrieve the object in the launch environment.
    public static var launchEnvironmentKey = "mocked-data"
}
