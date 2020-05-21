// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public protocol LogHandler {
    func log(_ event: LogEvent)
}
