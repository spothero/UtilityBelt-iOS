// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// The delegate completion
public typealias HTTPSessionDelegateCompletion = ((Data?, URLResponse?, Error?) -> Void)

public protocol HTTPSessionDelegate: URLSessionDownloadDelegate {
    
    var completion: HTTPSessionDelegateCompletion? { get set }
    
}
