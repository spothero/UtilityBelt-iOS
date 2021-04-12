// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation
import UtilityBeltNetworking

public extension StubbedDataCollection {
    /// Returns a stubbed response if there is a stubbed request that matches.
    /// - Parameter urlRequest: The URL, URLRequest, or URL String to match against stubbed requests.
    func getResponse(for urlRequest: URLRequestConvertible) -> StubResponse? {
        let request = StubRequest(urlRequest: urlRequest)
        return self.getResponse(for: request)
    }
    
    /// Determines whether or not a matching request has been stubbed.
    /// - Parameter urlRequest: The URL, URLRequest, or URL String to match against stubbed requests.
    func hasStub(for urlRequest: URLRequestConvertible) -> Bool {
        let request = StubRequest(urlRequest: urlRequest)
        return self.hasStub(for: request)
    }
    
    /// Adds a response to the stub response collection.
    /// - Parameter urlRequest: The URL, URLRequest, or URL String to stub.
    /// - Parameter response: The response to return upon receiving the given request.
    func stub(_ urlRequest: URLRequestConvertible, with response: StubResponse) {
        let request = StubRequest(urlRequest: urlRequest)
        return self.stub(request, with: response)
    }
}
