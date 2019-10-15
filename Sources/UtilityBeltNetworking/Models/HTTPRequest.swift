// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public class HTTPRequest {
    // MARK: Properties
    
    private var urlComponents = URLComponents()

    public private(set) var headers: [String: String] = [:]
    public private(set) var method: HTTPMethod = .get
    public private(set) var parameters: [String: Any]?
    public private(set) var parameterEncoding: ParameterEncoding = .defaultEncodingForMethod

    // TODO: Implement timeout in HTTPClient
    public private(set) var timeout: TimeInterval?

    private weak var delegate: HTTPRequesting?

    public var url: URL? {
        let encoding = self.parameterEncoding.resolvedEncoding(for: self.method)

        switch encoding {
        case .queryString:
            var components = self.urlComponents
            if let parameters = self.parameters {
                components.setQueryItems(with: parameters)
                return components.url
            } else {
                fallthrough
            }
        default:
            return self.urlComponents.url
        }
    }
    
    // MARK: Methods: Initializers

    init(url: URLConvertible? = nil, delegate: HTTPRequesting? = nil) {
        self.delegate = delegate
        self.url(url)
    }
    
    // MARK: Methods: Declarative Setters

    @discardableResult
    public func method(_ method: HTTPMethod) -> HTTPRequest {
        self.method = method
        return self
    }

    @discardableResult
    public func url(_ url: URLConvertible?) -> HTTPRequest {
        if let url = try? url?.asURL(), let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            self.urlComponents = urlComponents
        } else {
            self.urlComponents = URLComponents()
        }

        return self
    }

    @discardableResult
    public func host(_ host: String?) -> HTTPRequest {
        self.urlComponents.host = host
        return self
    }

    @discardableResult
    public func path(_ path: String) -> HTTPRequest {
        var path = path

        // If the path doesn't have a leading slash, add one
        if !path.hasPrefix("/") {
            path = "/\(path)"
        }

        self.urlComponents.path = path
        return self
    }

    @discardableResult
    public func port(_ port: Int?) -> HTTPRequest {
        self.urlComponents.port = port
        return self
    }

    @discardableResult
    public func scheme(_ scheme: String?) -> HTTPRequest {
        self.urlComponents.scheme = scheme
        return self
    }

    @discardableResult
    public func header(_ value: String, for header: String) -> HTTPRequest {
        self.headers[header] = value
        return self
    }

    @discardableResult
    public func header(_ value: String, for header: HTTPHeader) -> HTTPRequest {
        self.headers[header.rawValue] = value
        return self
    }

    @discardableResult
    public func headers(_ headers: [String: String]) -> HTTPRequest {
        self.headers = headers
        return self
    }

    @discardableResult
    public func headers(_ headers: [HTTPHeader: String]) -> HTTPRequest {
        var newHeaders = [String: String]()

        for header in headers {
            newHeaders[header.key.rawValue] = header.value
        }

        self.headers = newHeaders

        return self
    }

    @discardableResult
    public func parameters(_ parameters: [String: Any]?) -> HTTPRequest {
        self.parameters = parameters
        return self
    }

    @discardableResult
    public func parameterEncoding(_ parameterEncoding: ParameterEncoding) -> HTTPRequest {
        self.parameterEncoding = parameterEncoding
        return self
    }

    @discardableResult
    public func timeout(_ timeout: TimeInterval?) -> HTTPRequest {
        self.timeout = timeout
        return self
    }
    
    // MARK: Methods: Response

    // TODO: Is there really any purpose to allowing a nil completion block?
    public func response(completion: DataTaskCompletion? = nil) {
        if let delegate = self.delegate {
            self.delegate.response(for: self, completion: completion)
        } else {
            completion?(.errorResult(UBNetworkError.httpClientNotInitialized))
        }
    }

    // TODO: Is there really any purpose to allowing a nil completion block?
    public func response<T>(completion: DecodableTaskCompletion<T>? = nil) {
        if let delegate = self.delegate {
            self.delegate.response(for: self, completion: completion)
        } else {
            completion?(.errorResult(UBNetworkError.httpClientNotInitialized))
        }
    }
}

// MARK: Extension: URLRequestConvertible

extension HTTPRequest: URLRequestConvertible {
    public func asURLRequest() throws -> URLRequest {
        if let url = self.url {
            var request = URLRequest(url: url)
            request.httpMethod = self.method.rawValue
            request.setParameters(self.parameters, method: self.method, encoding: self.parameterEncoding)

            return request
        } else {
            throw UBNetworkError.invalidURL(self.url)
        }
    }
}
