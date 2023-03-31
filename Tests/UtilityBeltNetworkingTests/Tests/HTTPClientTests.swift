// Copyright © 2023 SpotHero, Inc. All rights reserved.

import Foundation
import Sham_XCTestSupport
@testable import UtilityBeltNetworking
import XCTest

@available(iOS 13.0, *)
final class HTTPClientTests: XCTestCase, URLRequesting {
    var task: Task<DataTaskSuccess, Error>!

    func testCancellation() async throws {
        // We capture the request in a task so we can cancel it later.
        // We're also using async let so that we can begin the request but catch the error later.
        let client = HTTPClient()
        async let task = Task { try client.request(self.urlRequest(url: "https://spothero.com")) }

        // Cancel the request immediately through Swift Concurrency
        await task.cancel()

        // Then we can assert that the failure is:
        // - of type `RequestError`
        // - the underlying error came from the URL loading system and isn't a generic
        // Swift cancellation error.
        do {
            _ = try await task.value
        } catch let error as RequestError {
            let nsError = error.underlyingError as NSError
            XCTAssertEqual(nsError.code, NSURLErrorCancelled)
        }
    }
}
