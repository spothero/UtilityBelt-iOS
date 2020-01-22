// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension HTTPURLResponse {
    /// A convenience initializer to get an empty, invalid HTTPURLResponse with an undefined status code.
    /// An HTTPURLResponse initialized this way should indicate an error in the underlying HTTPClient.
    static func undefined(_ url: URL) -> HTTPURLResponse {
        return HTTPURLResponse(url: url, statusCode: HTTPStatusCode.undefined.rawValue, httpVersion: nil, headerFields: nil) ?? HTTPURLResponse()
    }
}
