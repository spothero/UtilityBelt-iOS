// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// The result that is returned from an HTTP request.
public protocol HTTPResult {
    /// The type of data that is returned by the request.
    associatedtype DataType

    /// The data returned by the request.
    var data: DataType { get }

    /// The HTTP response returned by the request.
    var response: HTTPURLResponse? { get }

    /// The status of the response, based on status codes and whether or not there were any errors.
    var status: HTTPResultStatus { get }

    /// Initializes an HTTPResult, with status explicitly defined.
    init(data: DataType, response: HTTPURLResponse?, status: HTTPResultStatus)
}

public extension HTTPResult {
    /// Initializes an HTTPResult, with status based on whether or not an error was provided.
    init(data: DataType, response: HTTPURLResponse?, error: Error? = nil) {
        if let error = error {
            self.init(data: data, response: response, status: .failure(error))
        } else {
            self.init(data: data, response: response, status: .success)
        }
    }
}
