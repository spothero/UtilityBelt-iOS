// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public enum HTTPResultStatus {
    case success
    case failure(Error)
}

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

public struct DataResult: HTTPResult {
    public let data: Data?
    public let response: URLResponse?
    public let status: HTTPResultStatus
    
    public init(data: Data?, response: URLResponse?, status: HTTPResultStatus) {
        self.data = data
        self.response = response
        self.status = status
    }
}

public struct DecodableResult<T>: HTTPResult where T: Decodable {
    public let data: T?
    public let response: URLResponse?
    public let status: HTTPResultStatus
    
    public init(data: T?, response: URLResponse?, status: HTTPResultStatus) {
        self.data = data
        self.response = response
        self.status = status
    }
}
