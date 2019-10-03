// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public class MockURLProtocol: URLProtocol {
    public enum Error: Swift.Error {
        case invalidRequestURL
        case noResponse
    }

    override public class func canInit(with task: URLSessionTask) -> Bool {
        guard let currentRequest = task.currentRequest else {
            return false
        }
        
        return MockService.shared.canMockData(for: currentRequest)
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
                                           statusCode: stubResponse?.statusCode.rawValue ?? 400,
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
