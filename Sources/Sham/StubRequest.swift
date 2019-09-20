// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import UtilityBeltNetworking

public struct StubRequest: Hashable {
    // MARK: - Properties

    public let method: HTTPMethod?
    public let url: URL

    public var description: String {
        if let method = method {
            return "\(method): \(self.url.absoluteString)"
        } else {
            return self.url.absoluteString
        }
    }

    public var isValidForStubbing: Bool {
        return self.url.isValidForStubbing
    }

    // MARK: - Methods

    public init(method: HTTPMethod, url: URL) {
        self.method = method
        self.url = url
    }

    public init(url: URL) {
        self.method = .none
        self.url = url
    }

    public init(urlRequest: URLRequest) {
        if let rawHttpMethod = urlRequest.httpMethod,
            let httpMethod = HTTPMethod(rawValue: rawHttpMethod) {
            self.method = httpMethod
        } else {
            self.method = .none
        }

        self.url = urlRequest.url ?? .emptyRoute
    }

    public func canMockData(for request: StubRequest) -> Bool {
        // If this request is valid for all requests, return true
        guard self != .allRequests else {
            return true
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
        isIncluded = isIncluded && (self.url.scheme == request.url.scheme || self.url.scheme?.isEmpty != false)

        // Include any stubbed response where the host matches the incoming URL's host or is nil or empty
        isIncluded = isIncluded && (self.url.host == request.url.host || self.url.host?.isEmpty != false)

        // Include any stubbed response where the port matches the incoming URL's port or is nil
        isIncluded = isIncluded && (self.url.port == request.url.port || self.url.port == nil)

        // Include any stubbed response where the path matches the incoming URL's path or is empty
        isIncluded = isIncluded && (self.url.trimmedPath == request.url.trimmedPath || self.url.trimmedPath.isEmpty)

        // Include any stubbed response where the query matches the incoming URL' query or is nil or empty
        isIncluded = isIncluded && (self.url.query == request.url.query || self.url.query?.isEmpty != false)

        return isIncluded
    }
}

// MARK: - Convenience Initializers

public extension StubRequest {
    static var allRequests: StubRequest {
        return .http(.emptyRoute)
    }

    static func http(_ url: URL) -> StubRequest {
        return self.init(url: url)
    }

    static func connect(_ url: URL) -> StubRequest {
        return self.init(method: .connect, url: url)
    }

    static func delete(_ url: URL) -> StubRequest {
        return self.init(method: .delete, url: url)
    }

    static func get(_ url: URL) -> StubRequest {
        return self.init(method: .get, url: url)
    }

    static func head(_ url: URL) -> StubRequest {
        return self.init(method: .head, url: url)
    }

    static func options(_ url: URL) -> StubRequest {
        return self.init(method: .options, url: url)
    }

    static func patch(_ url: URL) -> StubRequest {
        return self.init(method: .patch, url: url)
    }

    static func post(_ url: URL) -> StubRequest {
        return self.init(method: .post, url: url)
    }

    static func put(_ url: URL) -> StubRequest {
        return self.init(method: .put, url: url)
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
