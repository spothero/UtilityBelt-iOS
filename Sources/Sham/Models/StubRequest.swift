// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation
import UtilityBeltNetworking

/// A request for stubbing response meant to mirror a URLRequest.
public struct StubRequest: Hashable, CustomStringConvertible, Codable {
    // MARK: - Properties
    
    /// The HTTP method to stub. If nil, stubs all methods.
    public let method: HTTPMethod?
    
    /// The URL to stub. This can be a fully qualified URL, a host, or a route.
    ///
    /// If this is only a host (eg. https://example.com), it will stub all requests to any URL with an _exact_ matching host,
    /// regardless of path or query string.
    ///
    /// If this is only a route (eg. /api/users/), it will stub all requests to any URL with an _exact_ matching path,
    /// regardless of host or query string.
    ///
    /// Query parameters are also evaluated, but the order does not matter.
    public let url: URL?
    
    /// The string representation of the request.
    public var description: String {
        guard let urlString = self.url?.sortedAbsoluteString else {
            return "INVALID: NO URL"
        }
        if let method = self.method {
            return "\(method.rawValue): \(urlString)"
        } else {
            return "ALL: \(urlString)"
        }
    }
    
    /// Whether or not the request is valid for stubbing.
    public var isValidForStubbing: Bool {
        return self.url?.isValidForStubbing == true
    }
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    /// Initializes a StubRequest.
    /// - Parameter method: The HTTP method to stub.
    /// - Parameter url: The URL to stub.
    public init(method: HTTPMethod, url: URLConvertible) {
        self.method = method
        self.url = try? url.asURL()
    }
    
    /// Initializes a StubRequest that stubs all HTTP methods for a given URL.
    /// - Parameter url: The URL to stub.
    public init(url: URLConvertible) {
        self.method = .none
        self.url = try? url.asURL()
    }
    
    /// Initializes a StubRequest by attempting to parse a URL and HTTP method out of a URLRequest.
    /// - Parameter urlRequest: The URLRequest to stub.
    public init(urlRequest: URLRequestConvertible) {
        if let rawHttpMethod = (try? urlRequest.asURLRequest())?.httpMethod,
           let httpMethod = HTTPMethod(rawValue: rawHttpMethod) {
            self.method = httpMethod
        } else {
            self.method = .none
        }
        
        self.url = try? urlRequest.asURLRequest().url
    }
    
    /// Determines whether or not this request is able to mock data for a given request.
    /// - Parameter request: The request to validate against.
    public func canMockData(for request: StubRequest) -> Bool {
        // If this request is valid for all requests, return true
        guard self != .allRequests else {
            return true
        }
        
        // If either request has no URL, return false
        guard let url = self.url, let requestURL = request.url else {
            return false
        }
        
        // If this request is not valid for the incoming request's HTTP method, return false
        guard self.method == .none || self.method == request.method else {
            return false
        }
        
        // If this request is valid for all routes, return true
        guard self.url != .emptyRoute else {
            return true
        }
        
        // Include any stubbed response where the scheme matches the incoming URL's scheme or is nil or empty
        let validScheme = url.scheme.isNilOrEmpty || url.scheme == requestURL.scheme
        
        // Include any stubbed response where the host matches the incoming URL's host or is nil or empty
        let validHost = url.host.isNilOrEmpty || url.host == requestURL.host
        
        // Include any stubbed response where the port matches the incoming URL's port or is nil
        let validPort = url.port == nil || url.port == requestURL.port
        
        // Include any stubbed response where the path matches the incoming URL's path or is empty
        let validPath = url.trimmedPath.isEmpty || url.trimmedPath == requestURL.trimmedPath
        
        return validScheme && validHost && validPort && validPath
    }
    
    /// A function that generates a score to represent how well a stored stubbed request matches an incoming request, with
    /// 0 indicating no match and higher scores representing better matches.
    /// - Parameter request: The incoming request to generate the priority score against.
    /// - Returns: A score representing how well this request matches an incoming request.  Hight scores indicate better matches.
    public func priorityScore(for request: StubRequest) -> Int {
        var score = 0
        
        if self.method == request.method {
            score += 1
        }
        
        guard let url = self.url else {
            return score
        }
        
        if url.scheme == request.url?.scheme {
            score += 1
        }
        
        if url.host == request.url?.host {
            score += 1
        }
        
        if url.port == request.url?.port {
            score += 1
        }
        
        if url.trimmedPath == request.url?.trimmedPath {
            score += 1
        }
        
        return score
    }
    
    /// Returns the count of parameters that the stub request has in common with the current stub. Compares
    /// key and value.
    /// - Parameter request: The request to compare with.
    /// - Returns: The count of parmaters that have the same key and value.
    public func matchingParameterCount(for request: StubRequest) -> Int {
        guard
            let url = self.url,
            let urlQueryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
            let requestURL = request.url,
            let requestURLQueryItems = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)?.queryItems else {
            return 0
        }
        
        // Now, we see what parameters we have that are equivalent.
        let equivalentParameters = requestURLQueryItems.filter {
            for query in urlQueryItems {
                if query.name == $0.name, query.value == $0.value {
                    return true
                }
            }
            return false
        }
        return equivalentParameters.count
    }
}

// MARK: - Convenience Initializers

public extension StubRequest {
    /// Initializes a StubRequest that matches all incoming requests.
    static var allRequests: StubRequest {
        return .http(URL.emptyRoute)
    }
    
    /// Initializes a StubRequest for a given URL that matches all HTTP methods.
    /// - Parameter url: The URL to stub.
    static func http(_ url: URLConvertible) -> StubRequest {
        return self.init(url: url)
    }
    
    /// Initializes a StubRequest for a given URL that matches the CONNECT HTTP method.
    /// - Parameter url: The URL to stub.
    static func connect(_ url: URLConvertible) -> StubRequest {
        return self.init(method: .connect, url: url)
    }
    
    /// Initializes a StubRequest for a given URL that matches the DELETE HTTP method.
    /// - Parameter url: The URL to stub.
    static func delete(_ url: URLConvertible) -> StubRequest {
        return self.init(method: .delete, url: url)
    }
    
    /// Initializes a StubRequest for a given URL that matches the GET HTTP method.
    /// - Parameter url: The URL to stub.
    static func get(_ url: URLConvertible) -> StubRequest {
        return self.init(method: .get, url: url)
    }
    
    /// Initializes a StubRequest for a given URL that matches the HEAD HTTP method.
    /// - Parameter url: The URL to stub.
    static func head(_ url: URLConvertible) -> StubRequest {
        return self.init(method: .head, url: url)
    }
    
    /// Initializes a StubRequest for a given URL that matches the OPTIONS HTTP method.
    /// - Parameter url: The URL to stub.
    static func options(_ url: URLConvertible) -> StubRequest {
        return self.init(method: .options, url: url)
    }
    
    /// Initializes a StubRequest for a given URL that matches the PATCH HTTP method.
    /// - Parameter url: The URL to stub.
    static func patch(_ url: URLConvertible) -> StubRequest {
        return self.init(method: .patch, url: url)
    }
    
    /// Initializes a StubRequest for a given URL that matches the POST HTTP method.
    /// - Parameter url: The URL to stub.
    static func post(_ url: URLConvertible) -> StubRequest {
        return self.init(method: .post, url: url)
    }
    
    /// Initializes a StubRequest for a given URL that matches the PUT HTTP method.
    /// - Parameter url: The URL to stub.
    static func put(_ url: URLConvertible) -> StubRequest {
        return self.init(method: .put, url: url)
    }
    
    /// Initializes a StubRequest for a given URL that matches the TRACE HTTP method.
    /// - Parameter url: The URL to stub.
    static func trace(_ url: URLConvertible) -> StubRequest {
        return self.init(method: .trace, url: url)
    }
}

// MARK: - Extensions

private extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
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
    
    /// Returns the absolute url string with sorted query parameters
    var sortedAbsoluteString: String? {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        urlComponents?.query = self.sortedQueryString
        return urlComponents?.string
    }
    
    /// Returns a string representing the sorted query parameters
    var sortedQueryString: String? {
        let splitCharacter: Character = "&"
        return self.query?.split(separator: splitCharacter).sorted(by: { $0 < $1 }).joined(separator: String(splitCharacter))
    }
}
