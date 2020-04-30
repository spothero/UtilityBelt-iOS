// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public typealias HTTPSessionDelegateCompletion = ((Data?, URLResponse?, Error?) -> Void)

public protocol HTTPSessionDelegate: URLSessionDownloadDelegate {
    
    var completion: HTTPSessionDelegateCompletion? { get set }
    
}
