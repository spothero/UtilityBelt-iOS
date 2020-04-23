// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public extension HTTPClient {
    /// An HTTPClient set up to work with in the background.
    static let background = HTTPClient(session: .background)
}
