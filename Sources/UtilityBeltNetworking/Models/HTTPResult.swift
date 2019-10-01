// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public protocol HTTPResult {
    associatedtype DataType

    var data: DataType? { get set }
    var response: URLResponse? { get set }
    var success: Bool { get }
    var error: Error? { get set }
}

public extension HTTPResult {
    var success: Bool {
        return self.data != nil && self.error == nil
    }
}

public struct DataResult: HTTPResult {
    public var data: Data?
    public var response: URLResponse?
    public var error: Error?
}

public struct DecodableResult<T>: HTTPResult where T: Decodable {
    public var data: T?
    public var response: URLResponse?
    public var error: Error?
}
