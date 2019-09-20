// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import UtilityBeltNetworking

public class MockService {
    // MARK: - Shared Instance

    public static let shared = MockService()

    // MARK: - Properties

    var isMockingAllRequests = true

    private var stubResponses = [StubRequest: StubResponse]()

    var isEmpty: Bool {
        return self.stubResponses.isEmpty
    }

    // MARK: - Methods

    // Because of the way URLProtocol registration works, using any instance other than the shared instance would cause problems
    private init() {}

    // MARK: Registration

    public func register() {
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    // MARK: Stubbing

    public func getResponse(for stubRequest: StubRequest?) -> StubResponse? {
        guard let stubRequest = stubRequest else {
            return nil
        }

        // Check for a match with the exact URL
        if let exactMatchResponse = self.stubResponses[stubRequest] {
            return exactMatchResponse
        }

        // Otherwise, find the most appropriate match
        let firstResponse = self.stubResponses.first { $0.key.canMockData(for: stubRequest) }

        return firstResponse?.value
    }

    public func hasStub(for stubRequest: StubRequest?) -> Bool {
        return self.getResponse(for: stubRequest) != nil
    }

    public func canMockData(for stubRequest: StubRequest?) -> Bool {
        return self.isMockingAllRequests || self.hasStub(for: stubRequest)
    }

    public func stub(_ request: StubRequest, with response: StubResponse) {
        // Ensure that the URL is valid for stubbing
        guard request.isValidForStubbing else {
            return
        }

        if self.stubResponses.contains(where: { $0.key == request }) {
            print("Stubbed data already exists for request '\(request.description)'. Updating with new data.")
        }

        self.stubResponses[request] = response
    }

    // MARK: URLRequest Convenience

    public func getResponse(for urlRequest: URLRequest?) -> StubResponse? {
        guard let urlRequest = urlRequest else {
            return nil
        }

        return self.getResponse(for: StubRequest(urlRequest: urlRequest))
    }

    public func hasStub(for urlRequest: URLRequest?) -> Bool {
        return self.getResponse(for: urlRequest) != nil
    }

    public func canMockData(for urlRequest: URLRequest?) -> Bool {
        return self.isMockingAllRequests || self.hasStub(for: urlRequest)
    }

    public func stub(_ urlRequest: URLRequest, with response: StubResponse) {
        let request = StubRequest(urlRequest: urlRequest)
        return self.stub(request, with: response)
    }

    // MARK: URL Convenience

    public func getResponse(for url: URL?) -> StubResponse? {
        guard let url = url else {
            return nil
        }

        return self.getResponse(for: .http(url))
    }

    public func hasStub(for url: URL?) -> Bool {
        return self.getResponse(for: url) != nil
    }

    public func canMockData(for url: URL?) -> Bool {
        return self.isMockingAllRequests || self.hasStub(for: url)
    }

    public func stub(_ url: URL, with response: StubResponse) {
        let request: StubRequest = .http(url)
        return self.stub(request, with: response)
    }

    // MARK: Utilities

    public func clearData() {
        self.stubResponses = [:]
    }
}
