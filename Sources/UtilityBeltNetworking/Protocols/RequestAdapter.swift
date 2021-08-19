// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public protocol RequestAdapter {
    /// Allows for adapting a `URLRequest` prior to the request being sent to the server.
    /// - Parameters:
    ///   - request: The `URLRequest` to adapt.
    ///   - completion: A closure that must be executed when request adapting is complete. If you
    /// do not wish to adapt the request, call the closure with a `.success`, passing in the original request.
    func adapt(_ request: URLRequest, completion: @escaping (Swift.Result<URLRequest, Error>) -> Void)
}
