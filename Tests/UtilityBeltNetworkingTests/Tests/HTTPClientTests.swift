// Copyright © 2023 SpotHero, Inc. All rights reserved.

import Foundation
@testable import UtilityBeltNetworking
import XCTest

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
final class HTTPClientTests: XCTestCase, URLRequesting {
    func testCancellation() async throws {
        // We capture the request in a task so we can cancel it later.
        let client = HTTPClient()
        let task = Task { try await client.request(self.urlRequest(url: "https://spothero.com")) }

        // Cancel the request immediately through Swift Concurrency
        task.cancel()

        // Then we can assert that the failure is a Swift CancellationError
        do {
            _ = try await task.value
            XCTFail("Task expected to fail")
        } catch let error as RequestError {
            XCTAssertTrue(error.underlyingError is CancellationError)
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }

    func testCancellationAfterStartingRequest() async throws {
        // We capture the request in a task so we can cancel it later.
        let client = HTTPClient()
        let task = Task { try await client.request(self.urlRequest(url: "https://spothero.com")) }

        // Add a delay so the task has a moment to start
        try await Task.sleep(nanoseconds: 500000000)

        // Cancel the request immediately through Swift Concurrency
        task.cancel()

        // Then we can assert that the failure is:
        // - of type `RequestError`
        // - the underlying error came from the URL loading system and isn't a generic
        // Swift cancellation error.
        do {
            _ = try await task.value
            XCTFail("Task expected to fail")
        } catch let error as RequestError {
            let nsError = error.underlyingError as NSError
            XCTAssertEqual(nsError.code, NSURLErrorCancelled)
        }
    }
}
