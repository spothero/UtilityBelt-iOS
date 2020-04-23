// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension URLSessionConfiguration {
    /// A URLSessionConfiguration set up to work in the background on top of the default settings.
    static var background: URLSessionConfiguration {
        return URLSessionConfiguration.background(withIdentifier: "com.spothero.swiftapi.background")
    }
}
