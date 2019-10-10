// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public extension URLSession {
    /// A URLSession set up to work with Sham's MockService on top of the default settings.
    static var sham: URLSession {
        return URLSession(configuration: .sham)
    }
}
