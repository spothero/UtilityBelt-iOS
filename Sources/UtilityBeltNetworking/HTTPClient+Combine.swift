// Copyright © 2020 SpotHero, Inc. All rights reserved.


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
    /// - Returns: A publisher that wraps a data task for the URL.
    func requestPublisher(_ url: URLConvertible,
                          method: HTTPMethod = .get,
                          parameters: ParameterDictionaryConvertible? = nil,
                          headers: HTTPHeaderDictionaryConvertible? = nil,
                          encoding: ParameterEncoding? = nil) -> AnyPublisher<Data, Error> {
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
            return Result<Data, Error>.Publisher(error).eraseToAnyPublisher()
        }
        
        if self.isDebugLoggingEnabled, let urlString = request.url?.absoluteString {
            self.log("Starting \(method.rawValue) request to \(urlString)")
        }
        
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
                
                // Attempt to lob the data as pretty printed JSON, otherwise just encode to utf8
                if self.isDebugLoggingEnabled,
                    let dataString: String = element.data.asPrettyPrintedJSON ?? String(data: element.data, encoding: .utf8) {
                    self.log(dataString)
                }
                
                return element.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Creates a request publisher which fetches raw data from an endpoint.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
    /// - Parameter parameters: The `Encodable` object to be converted into a String-keyed dictionary to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to send with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
    /// - Returns: A publisher that wraps a data task for the URL.
    // swiftlint:disable:next function_default_parameter_at_end
    func requestPublisher(_ url: URLConvertible,
                          method: HTTPMethod = .get,
                          parameters: Encodable,
                          headers: HTTPHeaderDictionaryConvertible? = nil,
                          encoding: ParameterEncoding? = nil) -> AnyPublisher<Data, Error> {
        return self.requestPublisher(url,
                                     method: method,
                                     parameters: try? parameters.asDictionary(),
                                     headers: headers,
                                     encoding: encoding)
    }
    
    // MARK: Decodable Object Response
    
    /// Creates a request publisher which fetches raw data from an endpoint and decodes it.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
    /// - Parameter parameters: The parameters to be converted into a String-keyed dictionary to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to send with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
    /// - Parameter decoder: The `JSONDecoder` to use when decoding the response data.
    /// - Returns: A publisher that wraps a data task for the URL.
    func requestPublisher<T: Decodable>(_ url: URLConvertible,
                                        method: HTTPMethod = .get,
                                        parameters: ParameterDictionaryConvertible? = nil,
                                        headers: HTTPHeaderDictionaryConvertible? = nil,
                                        encoding: ParameterEncoding? = nil,
                                        decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return self.requestPublisher(url, method: method, parameters: parameters, headers: headers, encoding: encoding)
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
    /// - Parameter decoder: The `JSONDecoder` to use when decoding the response data.
    /// - Returns: A publisher that wraps a data task for the URL.
    // swiftlint:disable:next function_default_parameter_at_end
    func requestPublisher<T: Decodable>(_ url: URLConvertible,
                                        method: HTTPMethod = .get,
                                        parameters: Encodable,
                                        headers: HTTPHeaderDictionaryConvertible? = nil,
                                        encoding: ParameterEncoding? = nil,
                                        decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return self.requestPublisher(url,
                                     method: method,
                                     parameters: try? parameters.asDictionary(),
                                     headers: headers,
                                     encoding: encoding,
                                     decoder: decoder)
    }
}
#endif
