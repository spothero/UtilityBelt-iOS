// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public protocol RequestRetrier {
    /// Allows for inspection of a failed request and determines if the request should be retried.
    /// - Parameters:
    ///   - request: The `Request` containing the `URLSessionTask` that failed.
    ///   - error: The error that triggered the call to retry.
    ///   - completion: A closure to indicate whether or not the request should be retried.
    func retry(_ request: Request, dueTo error: Error, completion: @escaping (Bool) -> Void)
}
