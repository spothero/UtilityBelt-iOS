// Copyright © 2019 SpotHero, Inc. All rights reserved.

@testable import UtilityBeltNetworking
import XCTest

final class ParameterEncodingTests: XCTestCase {
    var parameters: [String: Any] = [
        "bool": true,
        "double": 2.5,
        "integer": 1,
        "string": "foo",
        "dictionary": [
            "bool": true,
            "double": 2.5,
            "integer": 1,
            "string": "foo",
        ],
        "array": [
            "alice",
            "bob",
            "carol",
        ],
    ]

    func testParameterEncoding() {
        var components = URLComponents(string: "localhost")
        components?.setQueryItems(with: self.parameters)

        guard let queryItems = components?.queryItems else {
            return
        }

        for item in queryItems {
            print(item.name, item.value)
        }

        print(components?.percentEncodedQuery)
    }
}
