// Copyright © 2019 SpotHero, Inc. All rights reserved.

@testable import UtilityBeltNetworking

import XCTest

final class HTTPRequestTests: XCTestCase {
    private static let testURLString = "https://postman-echo.com:8080/get"
    private static let testURL = URL(string: testURLString)
    private static let testURLWithQueryString = URL(string: "\(testURLString)?foo=bar&fizz=buzz")

    private static let defaultTestParameters: [String: Any] = [
        "foo": "bar",
        "fizz": "buzz",
    ]

    func testURLTranslation() {
        let request = HTTPRequest(url: Self.testURLString)

        XCTAssertEqual(request.url, Self.testURL)
    }

    func testBuildRequest() {
        let request = Self.createRequest(for: .get)
        XCTAssertEqual(request.url, Self.testURL?.urlWithoutQueryString)
    }

    func testBuildGetRequestWithSimpleQueryString() {
        let request = Self.createRequest(for: .get, parameters: Self.defaultTestParameters)
        XCTAssertURLWithQueryStringEqual(request.url, Self.testURLWithQueryString)
    }

    func testBuildPostRequestWithNoQueryString() {
        let request = Self.createRequest(for: .post, parameters: Self.defaultTestParameters)
        XCTAssertEqual(request.url, Self.testURL?.urlWithoutQueryString)
    }

    func testBuildPostRequestWithQueryString() {
        let request = Self.createRequest(for: .get, parameters: Self.defaultTestParameters)
        XCTAssertURLWithQueryStringEqual(request.url, Self.testURLWithQueryString)
    }

    private static func createRequest(for method: HTTPMethod, parameters: [String: Any]? = nil) -> HTTPRequest {
        return HTTPRequest()
            .method(method)
            .scheme("https")
            .host("postman-echo.com")
            .port(8080)
            .path("get")
            .parameters(parameters)
    }
}

private func XCTAssertURLWithQueryStringEqual(_ urlA: URL?,
                                              _ urlB: URL?,
                                              _ message: String = "",
                                              file: StaticString = #file,
                                              line: UInt = #line) {
    XCTAssertEqual(urlA?.urlWithoutQueryString, urlB?.urlWithoutQueryString, message, file: file, line: line)

    XCTAssertURLQueryStringEqual(urlA?.query, urlB?.query, message, file: file, line: line)
}

private func XCTAssertURLQueryStringEqual(_ queryA: String?,
                                          _ queryB: String?,
                                          _ message: String = "",
                                          file: StaticString = #file,
                                          line: UInt = #line) {
    let requestQueryItems = queryA?.split(separator: "&").sorted()
    let testQueryItems = queryB?.split(separator: "&").sorted()

    XCTAssertEqual(requestQueryItems, testQueryItems, message, file: file, line: line)
}

private extension URL {
    var urlWithoutQueryString: URL? {
        // If there is no query, return self
        guard let query = self.query, !query.isEmpty else {
            return self
        }

        var urlString = self.absoluteString
        urlString = urlString.replacingOccurrences(of: "?\(query)", with: "")

        return URL(string: urlString)
    }
}
