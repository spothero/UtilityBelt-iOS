// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public extension HTTPClient {
    // MARK: Data Response
    
    /// Creates and sends a request which fetches raw data from an endpoint.
    /// - Parameters:
    ///   - request:    An object defining properties to make the request with.
    ///   - completion: The completion block to call when the request is completed.
    /// - Returns: The `URLSessionTask` for the request.
    @discardableResult
    func request(_ request: URLRequestConvertible,
                 completion: DataTaskCompletion? = nil) -> URLSessionTask? {
        var convertedRequest: URLRequest
        
        do {
            convertedRequest = try request.asURLRequest()
        } catch {
            DispatchQueue.main.async {
                completion?(.failure(error))
            }
            return nil
        }
        
        return self.request(convertedRequest, completion: completion)
    }
    
    /// Creates and sends a request which fetches raw data from an endpoint.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
    /// - Parameter parameters: The parameters to be converted into a String-keyed dictionary to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to send with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
    /// - Parameter completion: The completion block to call when the request is completed.
    /// - Returns: The `URLSessionTask` for the request.
    @discardableResult
    func request(_ url: URLConvertible,
                 method: HTTPMethod = .get,
                 parameters: ParameterDictionaryConvertible? = nil,
                 headers: HTTPHeaderDictionaryConvertible? = nil,
                 encoding: ParameterEncoding? = nil,
                 completion: DataTaskCompletion? = nil) -> URLSessionTask? {
        let request: URLRequest
        
        do {
            request = try URLRequest(url: url,
                                     method: method,
                                     parameters: parameters,
                                     headers: headers,
                                     encoding: encoding)
        } catch {
            DispatchQueue.main.async {
                completion?(.failure(error))
            }
            return nil
        }
        
        return self.request(request, completion: completion)
    }
    
    // MARK: Decodable Object Response
    
    /// Creates and sends a request which fetches raw data from an endpoint and decodes it.
    /// - Parameters:
    ///   - request:    An object defining properties to make the request with.
    ///   - decoder:    The `JSONDecoder` to use when decoding the response data.
    ///   - completion: The completion block to call when the request is completed.
    /// - Returns: The `URLSessionTask` for the request.
    @discardableResult
    func request<T: Decodable>(_ request: URLRequestConvertible,
                               decoder: JSONDecoder = JSONDecoder(),
                               completion: DecodableTaskCompletion<T>? = nil) -> URLSessionTask? {
        var convertedRequest: URLRequest
        
        do {
            convertedRequest = try request.asURLRequest()
        } catch {
            DispatchQueue.main.async {
                completion?(.failure(error))
            }
            return nil
        }
        
        return self.request(convertedRequest, decoder: decoder, completion: completion)
    }
    
    /// Creates and sends a request which fetches raw data from an endpoint and decodes it.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
    /// - Parameter parameters: The parameters to be converted into a String-keyed dictionary to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to send with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
    /// - Parameter decoder: The `JSONDecoder` to use when decoding the response data.
    /// - Parameter completion: The completion block to call when the request is completed.
    /// - Returns: The `URLSessionTask` for the request.
    @discardableResult
    func request<T: Decodable>(_ url: URLConvertible,
                               method: HTTPMethod = .get,
                               parameters: ParameterDictionaryConvertible? = nil,
                               headers: HTTPHeaderDictionaryConvertible? = nil,
                               encoding: ParameterEncoding? = nil,
                               decoder: JSONDecoder = JSONDecoder(),
                               completion: DecodableTaskCompletion<T>? = nil) -> URLSessionTask? {
        let request: URLRequest
        
        do {
            request = try URLRequest(url: url,
                                     method: method,
                                     parameters: parameters,
                                     headers: headers,
                                     encoding: encoding)
        } catch {
            DispatchQueue.main.async {
                completion?(.failure(error))
            }
            return nil
        }
        
        return self.request(request, decoder: decoder, completion: completion)
    }
}
