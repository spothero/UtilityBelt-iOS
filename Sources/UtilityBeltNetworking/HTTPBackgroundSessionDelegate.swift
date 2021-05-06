// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

class HTTPBackgroundSessionDelegate: NSObject, HTTPSessionDelegate {
    var completion: HTTPSessionDelegateCompletion?
    
    // MARK: - URLSessionDownloadDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            self.completion?(data, nil, nil)
        } catch {
            self.completion?(nil, nil, error)
        }
        self.completion = nil
    }
}
