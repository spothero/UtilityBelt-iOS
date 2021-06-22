// Copyright © 2021 SpotHero, Inc. All rights reserved.

#if canImport(Combine)
    import Combine
    import Foundation

    @available(iOS 13, macOS 10.15, tvOS 13.0, watchOS 6, *)
    public extension HTTPClient {
        // MARK: Data Response
        
        /// Creates a request publisher which fetches raw data from an endpoint.
        /// - Parameter url: The URL for the request. Accepts a URL or a String.
        /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
        /// - Parameter parameters: The parameters to be converted into a String-keyed dictionary to send in the query string or HTTP body.
        /// - Parameter headers: The HTTP headers to send with the request.
        /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
        /// - Parameter validators: An array of validators that will be applied to the response.
        /// - Parameter dispatchQueue: The dispatch queue on which the response will be published. Defaults to `.main`.
        /// - Returns: A publisher that wraps a data task for the URL.
        func requestPublisher(_ url: URLConvertible,
                              method: HTTPMethod = .get,
                              parameters: ParameterDictionaryConvertible? = nil,
                              headers: HTTPHeaderDictionaryConvertible? = nil,
                              encoding: ParameterEncoding? = nil,
                              validators: [ResponseValidator] = [],
                              dispatchQueue: DispatchQueue = .main) -> AnyPublisher<Data, Error> {
            let request: URLRequest
        
            do {
                request = try self.configuredURLRequest(
                    url: url,
                    method: method,
                    parameters: parameters,
                    headers: headers,
                    encoding: encoding
                )
            } catch {
                return Result<Data, Error>.Publisher(error)
                    .receive(on: dispatchQueue)
                    .eraseToAnyPublisher()
            }
        
            if self.isDebugLoggingEnabled, let urlString = request.url?.absoluteString {
                self.log("Starting \(method.rawValue) request to \(urlString)")
            }
        
            return self.session
                .dataTaskPublisher(for: request)
                .tryMap { data, response -> Data in
                    self.log("Request finished.")
                
                    self.log("[Response] \(response)")
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        for validator in validators {
                            try validator.validate(response: httpResponse)
                        }
                    }
                
                    // Attempt to lob the data as pretty printed JSON, otherwise just encode to utf8
                    if self.isDebugLoggingEnabled,
                       let dataString: String = data.asPrettyPrintedJSON ?? String(data: data, encoding: .utf8) {
                        self.log(dataString)
                    }
                
                    return data
                }
                .receive(on: dispatchQueue)
                .eraseToAnyPublisher()
        }
    
        /// Creates a request publisher which fetches raw data from an endpoint.
        /// - Parameter url: The URL for the request. Accepts a URL or a String.
        /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
        /// - Parameter parameters: The `Encodable` object to be converted into a String-keyed dictionary to send in the query string or HTTP body.
        /// - Parameter headers: The HTTP headers to send with the request.
        /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
        /// - Parameter validators: An array of validators that will be applied to the response.
        /// - Parameter dispatchQueue: The dispatch queue on which the response will be published. Defaults to `.main`.
        /// - Returns: A publisher that wraps a data task for the URL.
        // swiftlint:disable:next function_default_parameter_at_end
        func requestPublisher(_ url: URLConvertible,
                              method: HTTPMethod = .get,
                              parameters: Encodable,
                              headers: HTTPHeaderDictionaryConvertible? = nil,
                              encoding: ParameterEncoding? = nil,
                              validators: [ResponseValidator] = [],
                              dispatchQueue: DispatchQueue = .main) -> AnyPublisher<Data, Error> {
            return self.requestPublisher(url,
                                         method: method,
                                         parameters: try? parameters.asDictionary(),
                                         headers: headers,
                                         encoding: encoding,
                                         validators: validators,
                                         dispatchQueue: dispatchQueue)
        }
    
        // MARK: Decodable Object Response
    
        /// Creates a request publisher which fetches raw data from an endpoint and decodes it.
        /// - Parameter url: The URL for the request. Accepts a URL or a String.
        /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
        /// - Parameter parameters: The parameters to be converted into a String-keyed dictionary to send in the query string or HTTP body.
        /// - Parameter headers: The HTTP headers to send with the request.
        /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
        /// - Parameter validators: An array of validators that will be applied to the response. Defaults to ensuring a JSON mime type.
        /// - Parameter dispatchQueue: The dispatch queue on which the response will be published. Defaults to `.main`.
        /// - Parameter decoder: The `JSONDecoder` to use when decoding the response data.
        /// - Returns: A publisher that wraps a data task for the URL.
        func requestPublisher<T: Decodable>(_ url: URLConvertible,
                                            method: HTTPMethod = .get,
                                            parameters: ParameterDictionaryConvertible? = nil,
                                            headers: HTTPHeaderDictionaryConvertible? = nil,
                                            encoding: ParameterEncoding? = nil,
                                            validators: [ResponseValidator] = [.ensureMimeType(.json)],
                                            dispatchQueue: DispatchQueue = .main,
                                            decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
            return self.requestPublisher(url,
                                         method: method,
                                         parameters: parameters,
                                         headers: headers,
                                         encoding: encoding,
                                         validators: validators,
                                         dispatchQueue: dispatchQueue)
                .decode(type: T.self, decoder: decoder)
                .mapError { error in
                    switch error {
                    case let error as DecodingError:
                        return UBNetworkError.unableToDecode(String(describing: T.self), error)
                    default:
                        return error
                    }
                }
                .eraseToAnyPublisher()
        }
    
        /// Creates a request publisher which fetches raw data from an endpoint and decodes it.
        /// - Parameter url: The URL for the request. Accepts a URL or a String.
        /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
        /// - Parameter parameters: The `Encodable` object to be converted into a String-keyed dictionary to send in the query string or HTTP body.
        /// - Parameter headers: The HTTP headers to send with the request.
        /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
        /// - Parameter validators: An array of validators that will be applied to the response. Defaults to ensuring a JSON mime type.
        /// - Parameter dispatchQueue: The dispatch queue on which the response will be published. Defaults to `.main`.
        /// - Parameter decoder: The `JSONDecoder` to use when decoding the response data.
        /// - Returns: A publisher that wraps a data task for the URL.
        // swiftlint:disable:next function_default_parameter_at_end
        func requestPublisher<T: Decodable>(_ url: URLConvertible,
                                            method: HTTPMethod = .get,
                                            parameters: Encodable,
                                            headers: HTTPHeaderDictionaryConvertible? = nil,
                                            encoding: ParameterEncoding? = nil,
                                            validators: [ResponseValidator] = [.ensureMimeType(.json)],
                                            dispatchQueue: DispatchQueue = .main,
                                            decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
            return self.requestPublisher(url,
                                         method: method,
                                         parameters: try? parameters.asDictionary(),
                                         headers: headers,
                                         encoding: encoding,
                                         validators: validators,
                                         dispatchQueue: dispatchQueue,
                                         decoder: decoder)
        }
    }
#endif
