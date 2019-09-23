// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

extension URL: ExpressibleByStringLiteral {
    /// Initializes a URL by string value. Allows usage of a string literal anywhere that a URL is accepted.
    /// - Parameter value: The absolute string for the URL.
    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}
