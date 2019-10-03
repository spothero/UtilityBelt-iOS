// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public protocol HTTPResult {
    associatedtype DataType

    var data: DataType { get }
    var response: URLResponse? { get }
    var status: HTTPResultStatus { get }

    init(data: DataType, response: URLResponse?, status: HTTPResultStatus)
}

public extension HTTPResult {
    init(data: DataType, response: URLResponse?, error: Error? = nil) {
        if let error = error {
            self.init(data: data, response: response, status: .failure(error))
        } else {
            self.init(data: data, response: response, status: .success)
        }
    }
}
