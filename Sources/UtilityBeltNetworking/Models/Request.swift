// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public class Request {
    // MARK: Properties
    
    /// The initial URL request when the `Request` object was created.
    /// This may differ from the final URL request sent to the server
    /// if a `RequestAdapter` is used.
    private let initialURLRequest: URLRequest
    
    /// The session in which the request will be made.
    private let session: URLSession
    
    /// The current session task.
    private var task: URLSessionTask?
    
    /// An array of validators that will be applied to the response.
    private let validators: [ResponseValidator]
    
    /// An object that can intercept the url request.
    private let interceptor: RequestInterceptor?
    
    /// The block to call when the request has completed.
    private let completion: DataTaskCompletion?
    
    /// The dispatch queue that the completion will be called on.
    private let dispatchQueue: DispatchQueue
    
    // MARK: Initialization
    
    /// Create a new instance of a `Request`.
    /// - Parameters:
    ///   - urlRequest: The URL for the request.
    ///   - session: The session in which the request will be made.
    ///   - validators: An array of validators that will be applied to the response. Defaults to an empty array.
    ///   - interceptor: An object that can intercept the url request. Defaults to `nil`.
    ///   - dispatchQueue: The dispatch queue that the completion will be called on. Defaults to `.main`.
    ///   - completion: The block to call when the request has completed. Defaults to `nil`.
    public init(urlRequest: URLRequest,
                session: URLSession,
                validators: [ResponseValidator] = [],
                interceptor: RequestInterceptor? = nil,
                dispatchQueue: DispatchQueue = .main,
                completion: DataTaskCompletion? = nil) {
        self.initialURLRequest = urlRequest
        self.session = session
        self.validators = validators
        self.interceptor = interceptor
        self.dispatchQueue = dispatchQueue
        self.completion = completion
    }

    // MARK: Updating State
    
    /// Resumes the current task.
    public func resume() {
        if let currentTask = self.task {
            // If there's an existing task, resume that task.
            currentTask.resume()
        } else if let interceptor = self.interceptor {
            // If there is not an existing task, and there's a RequestInterceptor,
            // pass the request off to be adapted, then create start the task.
            interceptor.adapt(self.initialURLRequest) { result in
                switch result {
                case let .success(adaptedRequest):
                    self.performSessionTask(with: adaptedRequest)
                case let .failure(error):
                    self.completion?(.failure(error))
                }
            }
        } else {
            // Otherwise, create and start the task.
            self.performSessionTask(with: self.initialURLRequest)
        }
    }
    
    /// Cancels the current task.
    public func cancel() {
        // TODO: If a cancel request comes in prior to starting the task
        // (e.x. if the adapt operation is taking awhile), how do we
        // ensure the task doesn't start anyway and that the proper
        // cancellation error is returned?
        // https://spothero.atlassian.net/browse/IOS-3202
        self.task?.cancel()
    }
    
    /// Suspends the current task.
    public func suspend() {
        self.task?.suspend()
    }
    
    /// Creates and starts a session task with the given URL request.
    /// - Parameter urlRequest: The URL for the request.
    private func performSessionTask(with urlRequest: URLRequest) {
        let wrappedCompletion: HTTPSessionDelegateCompletion = { data, response, error in
            self.handleCompletedDataTask(originalURLRequest: urlRequest,
                                         data: data,
                                         urlResponse: response,
                                         error: error)
        }
        
        let task: URLSessionTask
        // When a background request is made, it must use a delegate
        // and be a download or upload task. Using a data task will fail
        // and using a completion will cause an assertion failure.
        if let delegate = self.session.delegate as? HTTPSessionDelegate {
            delegate.completion = wrappedCompletion
            task = self.session.downloadTask(with: urlRequest)
        } else {
            task = self.session.dataTask(with: urlRequest, completionHandler: wrappedCompletion)
        }

        self.task = task
        task.resume()
    }
    
    // MARK: Response Handling
    
    private func handleCompletedDataTask(originalURLRequest: URLRequest,
                                         data: Data?,
                                         urlResponse: URLResponse?,
                                         error: Error?) {
        HTTPClient.shared.log("Request finished.")
        
        if let urlResponse = urlResponse {
            HTTPClient.shared.log("[Response] \(urlResponse)")
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
            HTTPClient.shared.log("Response succeeded.")
            
            // Attempt to get the data as pretty printed JSON, otherwise just encode to utf8
            if let dataString: String = data.asPrettyPrintedJSON ?? String(data: data, encoding: .utf8) {
                HTTPClient.shared.log(dataString)
            }
        case let .failure(error):
            HTTPClient.shared.log("Response failed. Error: \(error.localizedDescription)")
        }
        
        // Create the DataResponse object containing all necessary information from the response
        let dataResponse = DataResponse(request: originalURLRequest,
                                        response: httpResponse,
                                        data: data,
                                        result: result)
        
        self.dispatchQueue.async {
            // Fire the completion!
            self.completion?(dataResponse)
        }
    }
}
