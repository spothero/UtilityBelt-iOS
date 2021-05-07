// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public typealias HTTPSessionDelegateCompletion = ((Data?, URLResponse?, Error?) -> Void)

/// The session delegate to use when downloading a request in the background.
/// A delegate is required to be used and only download or upload tasks are allowed
/// when the app is in the background.
public protocol HTTPSessionDelegate: URLSessionDownloadDelegate {
    var completion: HTTPSessionDelegateCompletion? { get set }
}
