// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

/// An enumeration of launch arguments used when launching an XCUIApplication.
public enum LaunchArgument {
    /// An custom argument.
    case custom(value: String)
    // TODO: https://spothero.atlassian.net/browse/IOS-2719 Set up proper command line arguments and user defaults.
}
