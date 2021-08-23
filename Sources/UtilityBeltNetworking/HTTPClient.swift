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
    /// - Parameter request: The `URLRequest` to make the request with.
    /// - Parameter validators: An array of validators that will be applied to the response.
    /// - Parameter dispatchQueue: The dispatch queue that the completion will be called on. Defaults to `.main`.
    /// - Parameter completion: The completion block to call when the request is completed.
    /// - Returns: The `URLSessionTask` for the request.
    @discardableResult
    public func request(_ request: URLRequest,
                        validators: [ResponseValidator] = [],
                        dispatchQueue: DispatchQueue = .main,
                        completion: DataTaskCompletion? = nil) -> URLSessionTask? {
        self.logStart(of: request)
        
        // Make the request mutable.
        var request = request
        
        // Set the timeout interval of the request, if applicable.
        if let timeoutInterval = self.timeoutInterval {
            request.timeoutInterval = timeoutInterval
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
    
    // MARK: Decodable Object Response
    
    /// Creates and sends a request which fetches raw data from an endpoint and decodes it.
    /// - Parameter request: The `URLRequest` to make the request with.
    /// - Parameter validators: An array of validators that will be applied to the response. Defaults to ensuring a JSON mime type on the response.
    /// - Parameter dispatchQueue: The dispatch queue that the completion will be called on. Defaults to `.main`.
    /// - Parameter decoder: The `JSONDecoder` to use when decoding the response data.
    /// - Parameter completion: The completion block to call when the request is completed.
    /// - Returns: The `URLSessionTask` for the request.
    @discardableResult
    public func request<T: Decodable>(_ request: URLRequest,
                                      validators: [ResponseValidator] = [.ensureMimeType(.json)],
                                      dispatchQueue: DispatchQueue = .main,
                                      decoder: JSONDecoder = JSONDecoder(),
                                      completion: DecodableTaskCompletion<T>? = nil) -> URLSessionTask? {
        return self.request(
            request,
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
    
    // MARK: Utilities
    
    func log(_ message: Any) {
        guard self.isDebugLoggingEnabled else {
            return
        }
        
        print("[UtilityBeltNetworking] \(message)")
    }
    
    func logStart(of request: URLRequest) {
        if self.isDebugLoggingEnabled, let urlString = request.url?.absoluteString {
            self.log("Starting request to \(urlString): \(request)")
        }
    }
}
