// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public extension HTTPClient {
    /// An HTTPClient set up to work in the background.
    /// - Parameter identifier: The identifier for the backgrounded request configuration.
    static func background(withIdentifier identifier: String) -> HTTPClient {
        let sessionDelegate = HTTPBackgroundSessionDelegate()
        return HTTPClient(session: .background(withIdentifier: identifier, delegate: sessionDelegate))
    }
}
