// Copyright © 2020 SpotHero, Inc. All rights reserved.

#if canImport(XCTest)
    import UtilityBeltNetworking
    import XCTest

    public extension XCTestCase {
        /// Convenience method for stubbing new requests within an XCTestCase.
        /// - Parameter stubRequest: The request to stub.
        /// - Parameter response: The response to return.
        func stub(_ stubRequest: StubRequest, with response: StubResponse) {
            MockService.shared.stub(stubRequest, with: response)
        }

        /// Convenience method for stubbing new requests within an XCTestCase.
        /// - Parameter urlRequest: The request to stub.
        /// - Parameter response: The response to return.
        func stub(_ urlRequest: URLRequestConvertible, with response: StubResponse) {
            MockService.shared.stub(urlRequest, with: response)
        }
    }
#endif
