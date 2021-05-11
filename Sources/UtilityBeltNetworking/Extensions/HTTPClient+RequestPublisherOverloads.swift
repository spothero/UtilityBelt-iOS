// Copyright © 2021 SpotHero, Inc. All rights reserved.

#if canImport(Combine)
    import Combine
    import Foundation

    @available(iOS 13, macOS 10.15, tvOS 13.0, watchOS 6, *)
    public extension HTTPClient {
        // MARK: Data Response
        
        /// Creates a request publisher which fetches raw data from an endpoint.
        /// - Parameters:
        ///   - request: An object defining properties to make the request with.
        ///   - dispatchQueue: The `DispatchQueue` to make the request on.
        /// - Returns: A publisher that wraps a data task for the URL.
        func requestPublisher(_ request: URLRequestConvertible, on dispatchQueue: DispatchQueue = .main) -> AnyPublisher<Data, Error> {
            let convertedRequest: URLRequest
        
            do {
                convertedRequest = try request.asURLRequest()
            } catch {
                return Result<Data, Error>.Publisher(error).eraseToAnyPublisher()
            }
        
            return self.requestPublisher(convertedRequest, on: dispatchQueue)
        }
    
        /// Creates a request publisher which fetches raw data from an endpoint.
        /// - Parameters:
        ///   - url:           The URL for the request. Accepts a `URL` or a String.
        ///   - method:        The HTTP method for the request. Defaults to `GET`.
        ///   - parameters:    The parameters to be converted into a String-keyed dictionary to send in the query string or HTTP body.
        ///   - headers:       The HTTP headers to send with the request.
        ///   - encoding:      The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
        ///   - dispatchQueue: The `DispatchQueue` to make the request on.
        /// - Returns: A publisher that wraps a data task for the URL.
        func requestPublisher(_ url: URLConvertible,
                              method: HTTPMethod = .get,
                              parameters: ParameterDictionaryConvertible? = nil,
                              headers: HTTPHeaderDictionaryConvertible? = nil,
                              encoding: ParameterEncoding? = nil,
                              on dispatchQueue: DispatchQueue = .main) -> AnyPublisher<Data, Error> {
            let request: URLRequest
        
            do {
                request = try URLRequest(url: url,
                                         method: method,
                                         parameters: parameters,
                                         headers: headers,
                                         encoding: encoding)
            } catch {
                return Result<Data, Error>.Publisher(error).eraseToAnyPublisher()
            }
        
            return self.requestPublisher(request, on: dispatchQueue)
        }
        
        // MARK: Decodable Object Response
        
        /// Creates a request publisher which fetches raw data from an endpoint and decodes it.
        /// - Parameters:
        ///   - request:       The `URLRequest` to make the request with.
        ///   - decoder:       The `JSONDecoder` to use when decoding the response data.
        ///   - dispatchQueue: The `DispatchQueue` to make the request on.
        /// - Returns: A publisher that wraps a data task for the URL.
        func requestPublisher<T: Decodable>(_ request: URLRequestConvertible,
                                            decoder: JSONDecoder = JSONDecoder(),
                                            on dispatchQueue: DispatchQueue = .main) -> AnyPublisher<T, Error> {
            let convertedRequest: URLRequest
        
            do {
                convertedRequest = try request.asURLRequest()
            } catch {
                return Result<T, Error>.Publisher(error).eraseToAnyPublisher()
            }
        
            return self.requestPublisher(convertedRequest, decoder: decoder, on: dispatchQueue)
        }
    
        /// Creates a request publisher which fetches raw data from an endpoint and decodes it.
        /// - Parameters:
        ///   - url:           The URL for the request. Accepts a `URL` or a String.
        ///   - method:        The HTTP method for the request. Defaults to `GET`.
        ///   - parameters:    The parameters to be converted into a String-keyed dictionary to send in the query string or HTTP body.
        ///   - headers:       The HTTP headers to send with the request.
        ///   - encoding:      The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
        ///   - decoder:       The `JSONDecoder` to use when decoding the response data.
        ///   - dispatchQueue: The `DispatchQueue` to make the request on.
        /// - Returns: A publisher that wraps a data task for the URL.
        func requestPublisher<T: Decodable>(_ url: URLConvertible,
                                            method: HTTPMethod = .get,
                                            parameters: ParameterDictionaryConvertible? = nil,
                                            headers: HTTPHeaderDictionaryConvertible? = nil,
                                            encoding: ParameterEncoding? = nil,
                                            decoder: JSONDecoder = JSONDecoder(),
                                            on dispatchQueue: DispatchQueue = .main) -> AnyPublisher<T, Error> {
            let request: URLRequest
        
            do {
                request = try URLRequest(url: url,
                                         method: method,
                                         parameters: parameters,
                                         headers: headers,
                                         encoding: encoding)
            } catch {
                return Result<T, Error>.Publisher(error).eraseToAnyPublisher()
            }
            
            return self.requestPublisher(request, decoder: decoder, on: dispatchQueue)
        }
    }

#endif
