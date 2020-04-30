// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public class HTTPBackgroundSessionDelegate: NSObject, HTTPSessionDelegate {
    
    public var completion: HTTPSessionDelegateCompletion?
    
    // MARK: - URLSessionDownloadDelegate
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            DispatchQueue.main.async {
                self.completion?(data, nil, nil)
                self.completion = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.completion?(nil, nil, error)
                self.completion = nil
            }
        }
    }
    
}
