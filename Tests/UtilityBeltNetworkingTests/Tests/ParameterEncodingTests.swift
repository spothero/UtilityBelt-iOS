// Copyright © 2020 SpotHero, Inc. All rights reserved.

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
        ],
        "array": [
            "alice",
            "bob",
            "carol",
        ],
    ]

    // This is totally not a test case, this is just me hacking around for now -- ignore it
    func testParameterEncoding() {
        var components = URLComponents(string: "localhost")
        components?.setQueryItems(with: self.parameters)

        guard let queryItems = components?.queryItems else {
            return
        }

        for item in queryItems {
            print(item.name, String(describing: item.value))
        }

        print(String(describing: components?.percentEncodedQuery))
    }
}
