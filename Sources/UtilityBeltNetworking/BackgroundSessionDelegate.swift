// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

class BackgroundSessionDelegate: NSObject {
    
    var completion: ((Data?, URLResponse?, Error?) -> Void)?
    
}

extension BackgroundSessionDelegate: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        DispatchQueue.main.async {
            self.completion?(nil, nil, error)
            self.completion = nil
        }
    }
    
}

extension BackgroundSessionDelegate: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        DispatchQueue.main.async {
            do {
                let data = try Data(contentsOf: location)
                self.completion?(data, nil, nil)
            } catch {
                self.completion?(nil, nil, error)
            }
            self.completion = nil
        }
    }
}
