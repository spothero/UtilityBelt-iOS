// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension URLSession {
    /// A URLSession set up to work with in the background on top of the default settings.
    static var background: URLSession {
        return URLSession(configuration: .background, delegate: BackgroundSessionDelegate(), delegateQueue: nil)
    }
}
