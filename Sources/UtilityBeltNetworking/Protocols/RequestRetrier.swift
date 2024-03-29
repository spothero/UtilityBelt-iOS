// Copyright © 2022 SpotHero, Inc. All rights reserved.

import Foundation

public protocol RequestRetrier {
    /// Allows for inspection of a failed request and determines if the request should be retried.
    /// - Parameters:
    ///   - request: The `Request` containing the `URLSessionTask` that failed.
    ///   - error: The error that triggered the call to retry.
    ///   - data: The response data received from the request, if any.
    ///   - completion: A closure to indicate whether or not the request should be retried.
    func retry(_ request: Request, dueTo error: Error, data: Data?, completion: @escaping (Bool) -> Void)
}
