// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension URLSession {
    /// A URLSession set up to work with in the background on top of the default settings.
    /// - Parameter identifier: The identifier for the backgrounded request configuration.
    static func background(withIdentifier identifier: String, delegate: HTTPSessionDelegate) -> URLSession {
        return URLSession(configuration: .background(withIdentifier: identifier),
                          delegate: delegate,
                          delegateQueue: nil)
    }
}
