//
//  File.swift
//  
//
//  Created by Brian Drelling on 9/18/19.
//

import Foundation
import UtilityBeltNetworking

public class MockService {
    public static let shared = MockService()
    
    private var stubbedData = [URL: Data]()
    var isMockingAllRequests = true
    
    var isEmpty: Bool {
        return self.stubbedData.isEmpty
    }
    
    private init() {
        URLProtocol.registerClass(ShamURLProtocol.self)
    }
    
    public func getData(for url: URL?) -> Data? {
        guard let url = url else {
            return nil
        }
        
        // Check for a match with the exact URL
        if let exactMatchData = self.stubbedData[url] {
            return exactMatchData
        }
        
        // Otherwise, find the most appropriate match
        let firstDataPair = self.stubbedData.first { (key, value) in
            var isIncluded = true
            
            // Include any stubbed data where the scheme matches the incoming URL's scheme or is nil or empty
            isIncluded = isIncluded && (key.scheme == url.scheme || key.scheme?.isEmpty != false)
            
            // Include any stubbed data where the host matches the incoming URL's host or is nil or empty
            isIncluded = isIncluded && (key.host == url.host || key.host?.isEmpty != false)
            
            // Include any stubbed data where the port matches the incoming URL's port or is nil
            isIncluded = isIncluded && (key.port == url.port || key.port == nil)
            
            // Include any stubbed data where the path matches the incoming URL's path or is empty
            isIncluded = isIncluded && (key.trimmedPath == url.trimmedPath || key.trimmedPath.isEmpty)
            
            // Include any stubbed data where the query matches the incoming URL' query or is nil or empty
            isIncluded = isIncluded && (key.query == url.query || key.query?.isEmpty != false)
            
            return isIncluded
        }
        
        return firstDataPair?.value
    }
    
    public func hasData(for url: URL?) -> Bool {
        return self.getData(for: url) != nil
    }
    
    public func canMockData(for url: URL?) -> Bool {
        return self.isMockingAllRequests || self.hasData(for: url)
    }
    
    public func stub(_ url: URL, data: Data) {
        // Ensure that the URL is valid for stubbing
        guard url.isValidForStubbing else {
            return
        }
        
        if self.stubbedData.contains(where: { $0.key == url }) {
            print("Stubbed data already exists for URL '\(url.absoluteString)'. Replacing with new data.")
        }
        
        self.stubbedData[url] = data
    }
    
    public func stub<T>(_ url: URL, object: T) where T : Encodable {
        do {
            let data = try JSONEncoder().encode(object)
            self.stub(url, data: data)
        } catch { }
    }
    
    public func clearData() {
        self.stubbedData = [:]
    }
}

private extension String {
    func trimmingSlashes() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
}

private extension URL {
    var trimmedPath: String {
        return self.path.trimmingSlashes()
    }
    
    var isValidForStubbing: Bool {
        // In order for a URL to be considered valid for stubbing,
        // it must have a non-empty path or a non-nil and non-empty host
        return !self.path.isEmpty || self.host?.isEmpty == false
    }
}
