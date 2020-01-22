// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
import UtilityBeltNetworking

/// A subclass of URLProtocol that validates requests against stubs added via the MockService class.
public class MockURLProtocol: URLProtocol {
    public enum Error: Swift.Error {
        case invalidRequestURL
        case noResponse
    }

    override public class func canInit(with task: URLSessionTask) -> Bool {
        guard let currentRequest = task.currentRequest else {
            return false
        }

        return self.canInit(with: currentRequest)
    }

    override public class func canInit(with request: URLRequest) -> Bool {
        return MockService.shared.canMockData(for: request)
    }

    override public class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override public func startLoading() {
        guard let url = self.request.url else {
            self.client?.urlProtocol(self, didFailWithError: MockURLProtocol.Error.invalidRequestURL)
            return
        }

        let stubResponse = MockService.shared.getResponse(for: self.request)

        let httpResponse = HTTPURLResponse(url: url,
                                           statusCode: stubResponse?.statusCode.rawValue ?? HTTPStatusCode.badRequest.rawValue,
                                           httpVersion: nil,
                                           headerFields: stubResponse?.headers ?? [:])

        guard let response = httpResponse else {
            self.client?.urlProtocol(self, didFailWithError: MockURLProtocol.Error.noResponse)
            return
        }

        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

        if let data = stubResponse?.data {
            self.client?.urlProtocol(self, didLoad: data)
        }

        self.client?.urlProtocolDidFinishLoading(self)
    }

    override public func stopLoading() {
        // This is called if the request gets canceled or completed.
    }
}
