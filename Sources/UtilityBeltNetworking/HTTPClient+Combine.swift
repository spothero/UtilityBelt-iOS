// Copyright © 2021 SpotHero, Inc. All rights reserved.

#if canImport(Combine)
    import Combine
    import Foundation

    @available(iOS 13, macOS 10.15, tvOS 13.0, watchOS 6, *)
    public extension HTTPClient {
        // MARK: Data Response
    
        /// Creates a request publisher which fetches raw data from an endpoint.
        /// - Parameters:
        ///   - request: The `URLRequest` to make the request with.
        ///   - dispatchQueue: The `DispatchQueue` to make the request on.
        /// - Returns: A publisher that wraps a data task for the URL.
        func requestPublisher(_ request: URLRequest, on dispatchQueue: DispatchQueue = .main) -> AnyPublisher<Data, Error> {
            self.logStart(of: request)
        
            return self.session
                .dataTaskPublisher(for: request)
                .tryMap { element -> Data in
                    self.log("Request finished.")
                
                    self.log("[Response] \(element.response)")
                
                    // Convert the URLResponse into an HTTPURLResponse object.
                    // If it cannot be converted, use the undefined HTTPURLResponse object
                    let httpResponse = element.response as? HTTPURLResponse
                    let status = httpResponse?.status
                
                    if status?.responseType == .clientError || status?.responseType == .serverError {
                        // TODO: Update with better error
                        throw UBNetworkError.unexpectedError
                    }
                
                    // Attempt to log the data as pretty printed JSON, otherwise just encode to utf8
                    if self.isDebugLoggingEnabled,
                       let dataString: String = element.data.asPrettyPrintedJSON ?? String(data: element.data, encoding: .utf8) {
                        self.log(dataString)
                    }
                
                    return element.data
                }
                .receive(on: dispatchQueue)
                .eraseToAnyPublisher()
        }
    
        // MARK: Decodable Object Response
    
        /// Creates a request publisher which fetches raw data from an endpoint and decodes it.
        /// - Parameters:
        ///   - request:       The `URLRequest` to make the request with.
        ///   - decoder:       The `JSONDecoder` to use when decoding the response data.
        ///   - dispatchQueue: The `DispatchQueue` to make the request on.
        /// - Returns: A publisher that wraps a data task for the URL.
        func requestPublisher<T: Decodable>(_ request: URLRequest,
                                            decoder: JSONDecoder = JSONDecoder(),
                                            on dispatchQueue: DispatchQueue = .main) -> AnyPublisher<T, Error> {
            return self.requestPublisher(request, on: dispatchQueue)
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
    }

#endif
