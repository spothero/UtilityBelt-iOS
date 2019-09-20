// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}
