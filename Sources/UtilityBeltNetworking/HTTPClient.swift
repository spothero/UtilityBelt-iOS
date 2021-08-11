// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public protocol RequestRetrier {
    func retry(_ request: URLRequest, dueTo error: Error, completion: @escaping (Bool) -> Void)
}

public protocol RequestAdapter {
    func adapt(_ urlRequest: URLRequest, completion: @escaping (Result<URLRequest, Error>) -> Void)
}

public protocol RequestInterceptor: RequestAdapter, RequestRetrier {}

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
    
    public var interceptor: RequestInterceptor?
    
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

    // Save the url request
    // Ask the interceptor if it needs to alter the request
    // Start the request
    // Upon the request completing, as the interceptor if it needs to retry the request
    // Create a new request and retry
    public class DataRequest {
        private var urlRequests: [URLRequest] = []
        var urlRequest: URLRequest? {
            return self.task?.originalRequest
        }
        
        private var tasks: [URLSessionTask] = []
        private var task: URLSessionTask? {
            return self.tasks.last
        }
        
        private let validators: [ResponseValidator]
        private var interceptor: RequestInterceptor?
        private let dispatchQueue: DispatchQueue
        private var completion: DataTaskCompletion?
        public private(set) var retryCount = 0
        private var session: URLSession
        
        init(session: URLSession,
             dispatchQueue: DispatchQueue = .main,
             validators: [ResponseValidator] = [],
             interceptor: RequestInterceptor? = nil,
             completion: DataTaskCompletion? = nil) {
            self.session = session
            self.dispatchQueue = dispatchQueue
            self.validators = validators
            self.interceptor = interceptor
            self.completion = completion
        }
        
        func resume() {
            guard let task = self.task, task.state != .completed else {
                return
            }
            
            task.resume()
        }
        
        func perform(request: URLRequest) {
            if let interceptor = self.interceptor {
                interceptor.adapt(request) { result in
                    switch result {
                    case let .success(adaptedRequest):
                        self.createAndResumeDataTask(for: adaptedRequest)
                    case let .failure(error):
                        self.completion?(.failure(error))
                    }
                }
            } else {
                self.createAndResumeDataTask(for: request)
            }
        }
        
        private func createAndResumeDataTask(for request: URLRequest) {
            let task = self.session.dataTask(with: request) { data, response, error in
                self.handleCompletedDataTask(originalRequest: request,
                                             data: data,
                                             urlResponse: response,
                                             error: error)
            }
            self.tasks.append(task)
            self.resume()
        }
        
        private func handleCompletedDataTask(originalRequest: URLRequest,
                                             data: Data?,
                                             urlResponse: URLResponse?,
                                             error: Error?) {
            guard originalRequest == self.urlRequest else {
                // This is an old request, just return.
                return
            }
            
            if let error = error, let interceptor = self.interceptor {
                interceptor.retry(originalRequest, dueTo: error) { retry in
                    if retry {
                        self.retryCount += 1
                        self.perform(request: originalRequest)
                    } else {
                        self.completeDataRequest(request: originalRequest, data: data, urlResponse: urlResponse, error: error)
                    }
                }
            } else {
                self.completeDataRequest(request: originalRequest, data: data, urlResponse: urlResponse, error: error)
            }
        }
        
        private func completeDataRequest(request: URLRequest,
                                         data: Data?,
                                         urlResponse: URLResponse?,
                                         error: Error?) {
            guard let completion = self.completion else {
                return
            }
            
            // Convert the URLResponse into an HTTPURLResponse object.
            // If it cannot be converted, use the undefined HTTPURLResponse object
            let httpResponse = urlResponse as? HTTPURLResponse
            
            // Create a result object for improved handling of the response
            let result: Result<Data, Error> = {
                if let response = httpResponse {
                    do {
                        for validator in validators {
                            try validator.validate(response: response)
                        }
                    } catch {
                        return .failure(error)
                    }
                }
                if let data = data {
                    return .success(data)
                } else if let error = error {
                    return .failure(error)
                } else {
                    return .failure(UBNetworkError.unexpectedError)
                }
            }()
            
            // Create the DataResponse object containing all necessary information from the response
            let dataResponse = DataResponse(request: request,
                                            response: httpResponse,
                                            data: data,
                                            result: result)
            
            self.dispatchQueue.async {
                // Fire the completion!
                completion(dataResponse)
            }
        }
        
        public func cancel() {
            self.task?.cancel()
        }
    }
    
    @discardableResult
    public func newRequest(_ url: URLConvertible,
                           method: HTTPMethod = .get,
                           parameters: ParameterDictionaryConvertible? = nil,
                           headers: HTTPHeaderDictionaryConvertible? = nil,
                           encoding: ParameterEncoding? = nil,
                           validators: [ResponseValidator] = [],
                           dispatchQueue: DispatchQueue = .main,
                           completion: DataTaskCompletion? = nil) -> DataRequest? {
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
        
        let dataRequest = DataRequest(session: self.session,
                                      interceptor: self.interceptor,
                                      completion: completion)
        dataRequest.perform(request: urlRequest)
        
        return dataRequest
    }
    
    /// Creates and sends a request which fetches raw data from an endpoint.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
    /// - Parameter parameters: The parameters to be converted into a String-keyed dictionary to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to send with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
    /// - Parameter validators: An array of validators that will be applied to the response.
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
                        dispatchQueue: DispatchQueue = .main,
                        completion: DataTaskCompletion? = nil) -> URLSessionTask? {
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
            dispatchQueue.async {
                completion?(.failure(error))
            }
            return nil
        }
        
        if let urlString = request.url?.absoluteString {
            self.log("Starting \(method.rawValue) request to \(urlString)")
        }
        
        let completion: HTTPSessionDelegateCompletion = { data, urlResponse, error in
            self.log("Request finished.")
            
            if let urlResponse = urlResponse {
                self.log("[Response] \(urlResponse)")
            }
            
            // Convert the URLResponse into an HTTPURLResponse object.
            // If it cannot be converted, use the undefined HTTPURLResponse object
            let httpResponse = urlResponse as? HTTPURLResponse
            
            // Create a result object for improved handling of the response
            let result: Result<Data, Error> = {
                if let response = httpResponse {
                    do {
                        for validator in validators {
                            try validator.validate(response: response)
                        }
                    } catch {
                        return .failure(error)
                    }
                }
                if let data = data {
                    return .success(data)
                } else if let error = error {
                    return .failure(error)
                } else {
                    return .failure(UBNetworkError.unexpectedError)
                }
            }()
            
            switch result {
            case let .success(data):
                self.log("Response succeeded.")
                
                // Attempt to get the data as pretty printed JSON, otherwise just encode to utf8
                if let dataString: String = data.asPrettyPrintedJSON ?? String(data: data, encoding: .utf8) {
                    self.log(dataString)
                }
            case let .failure(error):
                self.log("Response failed. Error: \(error.localizedDescription)")
            }
            
            // Create the DataResponse object containing all necessary information from the response
            let dataResponse = DataResponse(request: request,
                                            response: httpResponse,
                                            data: data,
                                            result: result)
            
            dispatchQueue.async {
                // Fire the completion!
                completion?(dataResponse)
            }
        }
        
        let task: URLSessionTask
        // When a background request is made, it must use a delegate
        // and be a download or upload task. Using a data task will fail
        // and using a completion will cause an assertion failure.
        if let delegate = self.session.delegate as? HTTPSessionDelegate {
            delegate.completion = completion
            task = self.session.downloadTask(with: request)
        } else {
            task = self.session.dataTask(with: request, completionHandler: completion)
        }
        task.resume()
        
        return task
    }
    
    /// Creates and sends a request which fetches raw data from an endpoint.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request. Defaults to `GET`.
    /// - Parameter parameters: The `Encodable` object to be converted into a String-keyed dictionary to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to send with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses the default encoding for the provided HTTP method.
    /// - Parameter validators: An array of validators that will be applied to the response.
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
                        dispatchQueue: DispatchQueue = .main,
                        completion: DataTaskCompletion? = nil) -> URLSessionTask? {
        self.request(url,
                     method: method,
                     parameters: try? parameters.asDictionary(),
                     headers: headers,
                     encoding: encoding,
                     validators: validators,
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
                                      dispatchQueue: DispatchQueue = .main,
                                      decoder: JSONDecoder = JSONDecoder(),
                                      completion: DecodableTaskCompletion<T>? = nil) -> URLSessionTask? {
        return self.request(
            url,
            method: method,
            parameters: parameters,
            headers: headers,
            encoding: encoding,
            validators: validators,
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
    
    @discardableResult
    public func newRequest<T: Decodable>(_ url: URLConvertible,
                                         method: HTTPMethod = .get,
                                         parameters: ParameterDictionaryConvertible? = nil,
                                         headers: HTTPHeaderDictionaryConvertible? = nil,
                                         encoding: ParameterEncoding? = nil,
                                         validators: [ResponseValidator] = [.ensureMimeType(.json)],
                                         dispatchQueue: DispatchQueue = .main,
                                         decoder: JSONDecoder = JSONDecoder(),
                                         completion: DecodableTaskCompletion<T>? = nil) -> HTTPClient.DataRequest? {
        return self.newRequest(
            url,
            method: method,
            parameters: parameters,
            headers: headers,
            encoding: encoding,
            validators: validators,
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
                                      dispatchQueue: DispatchQueue = .main,
                                      decoder: JSONDecoder = JSONDecoder(),
                                      completion: DecodableTaskCompletion<T>? = nil) -> URLSessionTask? {
        self.request(url,
                     method: method,
                     parameters: try? parameters.asDictionary(),
                     headers: headers,
                     encoding: encoding,
                     validators: validators,
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

private extension DataResponse {
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
