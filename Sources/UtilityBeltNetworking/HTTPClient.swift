// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

/// A completion handler for requests that return raw data results.
public typealias DataTaskCompletion = DecodableTaskCompletion<Data>

/// A completion handler for requests that return decoded object results.
public typealias DecodableTaskCompletion<T: Decodable> = (DataResponse<T, Error>) -> Void

/// A lightweight HTTP Client that supports data tasks
public class HTTPClient {
    // MARK: - Shared Instance
    
    /// The shared HTTP Client instance.
    public static let shared = HTTPClient()
    
    // MARK: - Properties
    
    /// The URLSession that is used for all requests.
    let session: URLSession
    
    /// Whether or not the client should be logging requests. Defaults to `false`.
    public var isDebugLoggingEnabled = false
    
    /// The timeout interval to use when waiting for additional data. When the request timer reaches the specified interval without receiving
    /// any new data, it triggers a timeout. If this property is set to `nil`, this property is ignored and the default value of 60 seconds is used.
    ///
    /// The value can be overridden by the session configuration if the session configuration `timeoutIntervalForRequest` property is
    /// set to be more restrictive. https://stackoverflow.com/a/54806389
    public var timeoutInterval: TimeInterval?
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    /// Initializes a new HTTPClient with a given URLSession.
    /// - Parameter session: The URLSession to use for all requests.
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: Data Response
    
    /// Creates and sends a request which fetches raw data from an endpoint.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
    /// - Parameter parameters: The parameters to be converted into a String-keyed dictionary to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to send with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
    /// - Parameter validators: An array of validators that will be applied to the response.
    /// - Parameter interceptor: An object that can intercept the url request. Defaults to `nil`.
    /// - Parameter dispatchQueue: The dispatch queue that the completion will be called on. Defaults to `.main`.
    /// - Parameter completion: The completion block to call when the request is completed.
    /// - Returns: The `URLSessionTask` for the request.
    @discardableResult
    public func request(_ url: URLConvertible,
                        method: HTTPMethod = .get,
                        parameters: ParameterDictionaryConvertible? = nil,
                        headers: HTTPHeaderDictionaryConvertible? = nil,
                        encoding: ParameterEncoding? = nil,
                        validators: [ResponseValidator] = [],
                        interceptor: RequestInterceptor? = nil,
                        dispatchQueue: DispatchQueue = .main,
                        completion: DataTaskCompletion? = nil) -> Request? {
        let urlRequest: URLRequest
        
        do {
            urlRequest = try self.configuredURLRequest(
                url: url,
                method: method,
                parameters: parameters,
                headers: headers,
                encoding: encoding
            )
        } catch {
            dispatchQueue.async {
                completion?(.failure(error))
            }
            return nil
        }
        
        if let urlString = urlRequest.url?.absoluteString {
            self.log("Starting \(method.rawValue) request to \(urlString)")
        }
        
        let request = Request(urlRequest: urlRequest,
                              session: self.session,
                              validators: validators,
                              interceptor: interceptor,
                              dispatchQueue: dispatchQueue,
                              completion: completion)
        request.resume()
        return request
    }
    
    /// Creates and sends a request which fetches raw data from an endpoint.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
    /// - Parameter parameters: The `Encodable` object to be converted into a String-keyed dictionary to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to send with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
    /// - Parameter validators: An array of validators that will be applied to the response.
    /// - Parameter interceptor: An object that can intercept the url request. Defaults to `nil`.
    /// - Parameter dispatchQueue: The dispatch queue that the completion will be called on. Defaults to `.main`.
    /// - Parameter completion: The completion block to call when the request is completed.
    /// - Returns: The `URLSessionTask` for the request.
    @discardableResult
    // swiftlint:disable:next function_default_parameter_at_end
    public func request(_ url: URLConvertible,
                        method: HTTPMethod = .get,
                        parameters: Encodable,
                        headers: HTTPHeaderDictionaryConvertible? = nil,
                        encoding: ParameterEncoding? = nil,
                        validators: [ResponseValidator] = [],
                        interceptor: RequestInterceptor? = nil,
                        dispatchQueue: DispatchQueue = .main,
                        completion: DataTaskCompletion? = nil) -> Request? {
        self.request(url,
                     method: method,
                     parameters: try? parameters.asDictionary(),
                     headers: headers,
                     encoding: encoding,
                     validators: validators,
                     interceptor: interceptor,
                     dispatchQueue: dispatchQueue,
                     completion: completion)
    }
    
    // MARK: Decodable Object Response
    
    /// Creates and sends a request which fetches raw data from an endpoint and decodes it.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
    /// - Parameter parameters: The parameters to be converted into a String-keyed dictionary to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to send with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
    /// - Parameter validators: An array of validators that will be applied to the response. Defaults to ensuring a JSON mime type on the response.
    /// - Parameter interceptor: An object that can intercept the url request. Defaults to `nil`.
    /// - Parameter dispatchQueue: The dispatch queue that the completion will be called on. Defaults to `.main`.
    /// - Parameter decoder: The `JSONDecoder` to use when decoding the response data.
    /// - Parameter completion: The completion block to call when the request is completed.
    /// - Returns: The `URLSessionTask` for the request.
    @discardableResult
    public func request<T: Decodable>(_ url: URLConvertible,
                                      method: HTTPMethod = .get,
                                      parameters: ParameterDictionaryConvertible? = nil,
                                      headers: HTTPHeaderDictionaryConvertible? = nil,
                                      encoding: ParameterEncoding? = nil,
                                      validators: [ResponseValidator] = [.ensureMimeType(.json)],
                                      interceptor: RequestInterceptor? = nil,
                                      dispatchQueue: DispatchQueue = .main,
                                      decoder: JSONDecoder = JSONDecoder(),
                                      completion: DecodableTaskCompletion<T>? = nil) -> Request? {
        return self.request(
            url,
            method: method,
            parameters: parameters,
            headers: headers,
            encoding: encoding,
            validators: validators,
            interceptor: interceptor,
            dispatchQueue: dispatchQueue
        ) { dataResponse in
            // Create a result object for improved handling of the response
            let result: Result<T, Error> = {
                switch dataResponse.result {
                case let .success(data) where T.self == Data.self:
                    // If T is Data, we have nothing to decode, so just return it as-is!
                    if let data = data as? T {
                        return .success(data)
                    } else {
                        return .failure(UBNetworkError.unableToDecode(String(describing: T.self), nil))
                    }
                case let .success(data):
                    do {
                        let decodedObject = try decoder.decode(T.self, from: data)
                        return .success(decodedObject)
                    } catch let error as DecodingError {
                        return .failure(UBNetworkError.unableToDecode(String(describing: T.self), error))
                    } catch {
                        return .failure(UBNetworkError.unableToDecode(String(describing: T.self), nil))
                    }
                case let .failure(error):
                    return .failure(error)
                }
            }()
            
            // Create the DataResponse object containing all necessary information from the response
            let response = DataResponse(request: dataResponse.request,
                                        response: dataResponse.response,
                                        data: dataResponse.data,
                                        result: result)
            
            // Fire the completion!
            completion?(response)
        }
    }
    
    /// Creates and sends a request which fetches raw data from an endpoint and decodes it.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
    /// - Parameter parameters: The `Encodable` object to be converted into a String-keyed dictionary to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to send with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
    /// - Parameter validators: An array of validators that will be applied to the response. Defaults to ensuring a JSON mime type on the response.
    /// - Parameter interceptor: An object that can intercept the url request. Defaults to `nil`.
    /// - Parameter dispatchQueue: The dispatch queue that the completion will be called on. Defaults to `.main`.
    /// - Parameter decoder: The `JSONDecoder` to use when decoding the response data.
    /// - Parameter completion: The completion block to call when the request is completed.
    /// - Returns: The `URLSessionTask` for the request.
    @discardableResult
    // swiftlint:disable:next function_default_parameter_at_end
    public func request<T: Decodable>(_ url: URLConvertible,
                                      method: HTTPMethod = .get,
                                      parameters: Encodable,
                                      headers: HTTPHeaderDictionaryConvertible? = nil,
                                      encoding: ParameterEncoding? = nil,
                                      validators: [ResponseValidator] = [.ensureMimeType(.json)],
                                      interceptor: RequestInterceptor? = nil,
                                      dispatchQueue: DispatchQueue = .main,
                                      decoder: JSONDecoder = JSONDecoder(),
                                      completion: DecodableTaskCompletion<T>? = nil) -> Request? {
        self.request(url,
                     method: method,
                     parameters: try? parameters.asDictionary(),
                     headers: headers,
                     encoding: encoding,
                     validators: validators,
                     interceptor: interceptor,
                     dispatchQueue: dispatchQueue,
                     decoder: decoder,
                     completion: completion)
    }
    
    // MARK: URL Request Configuration
    
    /// Creates a configured URLRequest.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
    /// - Parameter parameters: The parameters to be converted into a String-keyed dictionary to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to send with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
    /// - Returns: The configured `URLRequest` object.
    func configuredURLRequest(url: URLConvertible,
                              method: HTTPMethod = .get,
                              parameters: ParameterDictionaryConvertible? = nil,
                              headers: HTTPHeaderDictionaryConvertible? = nil,
                              encoding: ParameterEncoding? = nil) throws -> URLRequest {
        let url = try url.asURL()
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let timeoutInterval = self.timeoutInterval {
            request.timeoutInterval = timeoutInterval
        }
        
        request.setHeaders(headers)
        
        // Parameters must be set after setting headers, because encoding dictates (and therefore overrides) the Content-Type header
        request.setParameters(parameters, method: method, encoding: encoding)
        
        return request
    }
    
    func log(_ message: Any) {
        guard self.isDebugLoggingEnabled else {
            return
        }
        
        print("[UtilityBeltNetworking] \(message)")
    }
}

// MARK: - Extensions

internal extension DataResponse {
    /// Initializes a `DataResponse` object with `nil` request, response, and data properties
    /// and a failure result containing the given error.
    /// - Parameter error: The error to return in the result of the response.
    static func failure<T>(_ error: Error) -> DataResponse<T, Error> {
        return DataResponse<T, Error>(request: nil,
                                      response: nil,
                                      data: nil,
                                      result: .failure(error))
    }
}
