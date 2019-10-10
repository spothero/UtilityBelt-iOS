// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import UtilityBeltNetworking

/// A request for stubbing response meant to mirror a URLRequest.
public struct StubRequest: Hashable, CustomStringConvertible {
    // MARK: - Enums

    public enum StubRequestError: Error {
        case invalidURLString(String)
    }

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
        if let method = self.method, let url = self.url {
            return "\(method): \(url.absoluteString)"
        } else if let url = self.url {
            return "ALL: \(url.absoluteString)"
        } else {
            return "INVALID: NO URL"
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

        var isIncluded = true

        // Include any stubbed response where the scheme matches the incoming URL's scheme or is nil or empty
        isIncluded = isIncluded && (url.scheme == requestURL.scheme || url.scheme?.isEmpty != false)

        // Include any stubbed response where the host matches the incoming URL's host or is nil or empty
        isIncluded = isIncluded && (url.host == requestURL.host || url.host?.isEmpty != false)

        // Include any stubbed response where the port matches the incoming URL's port or is nil
        isIncluded = isIncluded && (url.port == requestURL.port || url.port == nil)

        // Include any stubbed response where the path matches the incoming URL's path or is empty
        isIncluded = isIncluded && (url.trimmedPath == requestURL.trimmedPath || url.trimmedPath.isEmpty)

        // Include any stubbed response where the query matches the incoming URL' query or is nil or empty
        isIncluded = isIncluded && (url.query == requestURL.query || url.query?.isEmpty != false)

        return isIncluded
    }
}

// MARK: - Convenience Initializers

public extension StubRequest {
    /// Initializes a StubRequest that matches all incoming requests.
    static var allRequests: StubRequest {
        return .http(URL.emptyRoute)!
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
