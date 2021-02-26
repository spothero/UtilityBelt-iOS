// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

extension NSNumber {
    var isBoolean: Bool {
        return CFGetTypeID(self as CFTypeRef) == CFBooleanGetTypeID()
    }
}
