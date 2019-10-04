// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import UtilityBeltNetworking

public class MockService {
    // MARK: - Shared Instance

    public static let shared = MockService()

    // MARK: - Properties

    public var defaultBundle: Bundle = .main
    public var isMockingAllRequests = true

    private var stubResponses = [StubRequest: StubResponse]()

    public var isEmpty: Bool {
        return self.stubResponses.isEmpty
    }

    // MARK: - Methods

    // Because of the way URLProtocol registration works, using any instance other than the shared instance would cause problems
    private init() {}

    // MARK: Registration

    public func register() {
        // TODO: Add some capability of also setting up a URLSessionConfiguration via a register() method
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    // MARK: Stubbing

    public func getResponse(for stubRequest: StubRequest) -> StubResponse? {
        // Check for a match with the exact URL
        if let exactMatchResponse = self.stubResponses[stubRequest] {
            return exactMatchResponse
        }

        // Otherwise, find the most appropriate match
        let firstResponse = self.stubResponses.first { $0.key.canMockData(for: stubRequest) }

        return firstResponse?.value
    }

    public func hasStub(for stubRequest: StubRequest) -> Bool {
        return self.getResponse(for: stubRequest) != nil
    }

    public func canMockData(for stubRequest: StubRequest) -> Bool {
        return self.isMockingAllRequests || self.hasStub(for: stubRequest)
    }

    public func stub(_ request: StubRequest, with response: StubResponse) {
        // Ensure that the URL is valid for stubbing
        guard request.isValidForStubbing else {
            // TODO: Throw error
            return
        }

        if self.stubResponses.contains(where: { $0.key == request }) {
            print("Stubbed data already exists for request '\(request.description)'. Updating with new data.")
        }

        self.stubResponses[request] = response
    }

    // MARK: URLRequest Convenience

    public func getResponse(for urlRequest: URLRequestConvertible) -> StubResponse? {
        return self.getResponse(for: StubRequest(urlRequest: urlRequest))
    }

    public func hasStub(for urlRequest: URLRequestConvertible) -> Bool {
        return self.getResponse(for: urlRequest) != nil
    }

    public func canMockData(for urlRequest: URLRequestConvertible) -> Bool {
        return self.isMockingAllRequests || self.hasStub(for: urlRequest)
    }

    public func stub(_ urlRequest: URLRequestConvertible, with response: StubResponse) {
        let request = StubRequest(urlRequest: urlRequest)
        return self.stub(request, with: response)
    }

    // MARK: Utilities

    public func clearData() {
        self.stubResponses = [:]
    }
}
