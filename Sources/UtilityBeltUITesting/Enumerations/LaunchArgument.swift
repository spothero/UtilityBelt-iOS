// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

/// An enumeration of launch arguments used when launching an XCUIApplication.
public enum LaunchArgument {
    case custom(key: String)
    case userDefault(key: String, value: String)
    case argument(key: String, value: String)
    
    /// Returns the properly formatted key for the launch argument.
    public var formattedKey: String {
        switch self {
        case let .custom(key):
            return key
        case let .userDefault(key, _):
            return "-" + key
        case let .argument(key, _):
            return "--" + key
        }
    }
}
