// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import OSLog

/// A convenience class that handles the Unified Logging framework.
/// - SeeAlso: [Unified Logging Documentation](https://developer.apple.com/documentation/os/logging)
@available(iOS 10.0, *)
public final class UBLogger {
    public static func log(message: StaticString, log: OSLog = .default, type: OSLogType = .default) {
        os_log(message, log: log, type: type)
    }

    public static func log(message: StaticString, log: OSLog = .default, type: OSLogType = .default, args: CVarArg...) {
        os_log(message, log: log, type: type, args)
    }
}
