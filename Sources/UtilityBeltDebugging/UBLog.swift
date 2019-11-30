// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import OSLog

public func UBLog(_ message: String,
                  log: OSLog = .default,
                  type: OSLogType = .debug) {
    UBLog("%{PUBLIC}@", log: log, type: type, args: [message])
}

public func UBLog(_ message: StaticString,
                  subsystem: String,
                  category: String,
                  type: OSLogType = .debug,
                  args: [CVarArg]) {
    UBLog(message, log: OSLog(subsystem: subsystem, category: category), type: type, args: args)
}

public func UBLog(_ message: StaticString,
                  log: OSLog = .default,
                  type: OSLogType = .debug,
                  args: [CVarArg]) {
    os_log(message, log: log, type: type, args)
}
