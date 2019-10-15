// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public class HTTPRequest {
    private var urlComponents = URLComponents()

    public private(set) var headers: [String: String] = [:]
    public private(set) var method: HTTPMethod = .get
    public private(set) var parameters: [String: Any]?
    public private(set) var parameterEncoding: ParameterEncoding = .defaultEncodingForMethod
    
    // TODO: Implement timeout in HTTPClient
    public private(set) var timeout: TimeInterval?

    private weak var delegate: HTTPRequesting?

    public var url: URL? {
        return self.urlComponents.url
    }

    init(url: URLConvertible, delegate: HTTPRequesting? = nil) {
        self.delegate = delegate
        self.url(url)
    }
    
    @discardableResult
    public func method(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    @discardableResult
    public func url(_ url: URLConvertible) -> Self {
        if let url = try? url.asURL(), let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            self.urlComponents = urlComponents
        } else {
            self.urlComponents = URLComponents()
        }
        
        return self
    }
    
    @discardableResult
    public func host(_ host: String?) -> Self {
        self.urlComponents.host = host
        return self
    }
    
    @discardableResult
    public func path(_ path: String) -> Self {
        self.urlComponents.path = path
        return self
    }
    
    @discardableResult
    public func scheme(_ scheme: String?) -> Self {
        self.urlComponents.scheme = scheme
        return self
    }
    
    @discardableResult
    public func header(_ value: String, for header: String) -> Self {
        self.headers[header] = value
        return self
    }
    
    @discardableResult
    public func header(_ value: String, for header: HTTPHeader) -> Self {
        self.headers[header.rawValue] = value
        return self
    }
    
    @discardableResult
    public func headers(_ headers: [String: String]) -> Self {
        self.headers = headers
        return self
    }
    
    @discardableResult
    public func headers(_ headers: [HTTPHeader: String]) -> Self {
        var newHeaders = [String: String]()

        for header in headers {
            newHeaders[header.key.rawValue] = header.value
        }

        self.headers = newHeaders

        return self
    }
    
    @discardableResult
    public func parameters(_ parameters: [String: Any]? = nil) -> Self {
        self.parameters = parameters
        return self
    }
    
    @discardableResult
    public func parameterEncoding(_ parameterEncoding: ParameterEncoding) -> Self {
        self.parameterEncoding = parameterEncoding
        return self
    }
    
    @discardableResult
    public func timeout(_ timeout: TimeInterval?) -> Self {
        self.timeout = timeout
        return self
    }

    // TODO: Is there really any purpose to allowing a nil completion block?
    public func response(completion: DataTaskCompletion? = nil) {
        self.delegate?.response(for: self, completion: completion)

        // TODO: If there is no delegate, respond with an error
    }
    
    // TODO: Is there really any purpose to allowing a nil completion block?
    public func response<T>(completion: DecodableTaskCompletion<T>? = nil) {
        self.delegate?.response(for: self, completion: completion)
    }
}
