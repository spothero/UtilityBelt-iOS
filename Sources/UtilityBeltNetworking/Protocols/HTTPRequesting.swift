// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public protocol HTTPRequesting: AnyObject {
    func response(for request: URLRequestConvertible, completion: DataTaskCompletion?)
    func response<T>(for request: URLRequestConvertible, completion: DecodableTaskCompletion<T>?)
}
