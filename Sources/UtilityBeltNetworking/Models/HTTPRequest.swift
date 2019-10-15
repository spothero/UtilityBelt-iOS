// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public class HTTPRequest {
    private var urlComponents: URLComponents
    
    public private(set) var method: HTTPMethod = .get
    public private(set) var parameters: [String: Any]? = nil
    public private(set) var parameterEncoding: ParameterEncoding = .defaultEncodingForMethod
    
    private weak var delegate: HTTPRequesting?
    
    public var url: URL? {
        return self.urlComponents.url
    }
    
    init(url: URLConvertible, delegate: HTTPRequesting? = nil) {
        self.delegate = delegate
        
        if let url = try? url.asURL(), let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            self.urlComponents = urlComponents
        } else {
            self.urlComponents = URLComponents()
        }
    }
    
    public func method(_ method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    public func host(_ host: String?) -> Self {
        self.urlComponents.host = host
        return self
    }
    
    public func scheme(_ scheme: String?) -> Self {
        self.urlComponents.scheme = scheme
        return self
    }
    
    public func parameters(_ parameters: [String: Any]? = nil) -> Self {
        self.parameters = parameters
        return self
    }
    
    public func parameterEncoding(_ parameterEncoding: ParameterEncoding) -> Self {
        self.parameterEncoding = parameterEncoding
        return self
    }
    
    public func response(completion: DataTaskCompletion? = nil) {
        self.delegate?.response(for: self, completion: completion)
        
        // TODO: If there is no delegate, respond with an error
    }
    
    public func response<T>(completion: DecodableTaskCompletion<T>? = nil) {
        self.delegate?.response(for: self, completion: completion)
    }
}

extension HTTPClient {
    func request(url: URLConvertible) -> HTTPRequest {
        return HTTPRequest(url: url, delegate: self)
    }
}

public protocol HTTPRequesting: AnyObject {
    func response(for request: URLRequestConvertible, completion: DataTaskCompletion?)
    func response<T>(for request: URLRequestConvertible, completion: DecodableTaskCompletion<T>?)
}
