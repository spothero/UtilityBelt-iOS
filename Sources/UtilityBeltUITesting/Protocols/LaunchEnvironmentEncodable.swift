// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// An object that can be encoded and injected into an app using the launch environment.
public protocol LaunchEnvironmentEncodable: StringEncodable {
    /// The key used when saving and retrieving the encoded object in the launch environment.
    static var launchEnvironmentKey: String { get }
}
