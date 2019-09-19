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
    
    private var stubbedResponses = [URL: StubResponse]()
    var isMockingAllRequests = true
    
    var isEmpty: Bool {
        return self.stubbedResponses.isEmpty
    }
    
    private init() {
        URLProtocol.registerClass(ShamURLProtocol.self)
    }
    
    public func getResponse(for url: URL?) -> StubResponse? {
        guard let url = url else {
            return nil
        }
        
        // Check for a match with the exact URL
        if let exactMatchResponse = self.stubbedResponses[url] {
            return exactMatchResponse
        }
        
        // Otherwise, find the most appropriate match
        let firstResponse = self.stubbedResponses.first { (key, value) in
            var isIncluded = true
            
            // Include any stubbed response where the scheme matches the incoming URL's scheme or is nil or empty
            isIncluded = isIncluded && (key.scheme == url.scheme || key.scheme?.isEmpty != false)
            
            // Include any stubbed response where the host matches the incoming URL's host or is nil or empty
            isIncluded = isIncluded && (key.host == url.host || key.host?.isEmpty != false)
            
            // Include any stubbed response where the port matches the incoming URL's port or is nil
            isIncluded = isIncluded && (key.port == url.port || key.port == nil)
            
            // Include any stubbed response where the path matches the incoming URL's path or is empty
            isIncluded = isIncluded && (key.trimmedPath == url.trimmedPath || key.trimmedPath.isEmpty)
            
            // Include any stubbed response where the query matches the incoming URL' query or is nil or empty
            isIncluded = isIncluded && (key.query == url.query || key.query?.isEmpty != false)
            
            return isIncluded
        }
        
        return firstResponse?.value
    }
    
    public func hasData(for url: URL?) -> Bool {
        return self.getResponse(for: url) != nil
    }
    
    public func canMockData(for url: URL?) -> Bool {
        return self.isMockingAllRequests || self.hasData(for: url)
    }
    
    public func stub(_ url: URL, with response: StubResponse) {
        // Ensure that the URL is valid for stubbing
        guard url.isValidForStubbing else {
            return
        }
        
        if self.stubbedResponses.contains(where: { $0.key == url }) {
            print("Stubbed data already exists for URL '\(url.absoluteString)'. Replacing with new data.")
        }
        
        self.stubbedResponses[url] = response
    }
    
//    public func stub<T>(_ url: URL, data: T) where T : Encodable {
//        do {
//            let encodedData = try JSONEncoder().encode(data)
//            self.stub(url, data: encodedData)
//        } catch { }
//    }
    
    public func clearData() {
        self.stubbedResponses = [:]
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

//public protocol Stubbable {
//    var value: Data { get }
//}
//
//public extension Stubbable {
//}

public struct StubResponse {
    public let data: Data
    
    static func data(_ data: Data) -> StubResponse {
        return StubResponse(data: data)
    }
    
    static func encodable<T>(_ encodable: T) -> StubResponse where T : Encodable {
        do {
            let data = try JSONEncoder().encode(encodable)
            return StubResponse(data: data)
        } catch {
            assertionFailure("Unable to encode type \(String(describing: T.self)) for stubbing.")
            return StubResponse(data: Data())
        }
    }
}

//protocol Stubbable {
//    func asData() -> Data?
//}
//
//extension Data: Stubbable {
//    func asData() -> Data? {
//        return self
//    }
//}
//
//extension Data: Stubbable {
//    func asData() -> Data? {
//        return try? JSONEncoder().encode(self)
//    }
//}
