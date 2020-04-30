// Copyright © 2020 SpotHero, Inc. All rights reserved.

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
    private let session: URLSession
    
    /// The protocol to handle session delegate responses, if needed.
    private weak var sessionDelegate: HTTPSessionDelegate?

    // MARK: - Methods

    // MARK: Initializers

    /// Initializes a new HTTPClient with a given URLSession.
    /// - Parameters:
    ///   - session: The URLSession to use for all requests.
    ///   - delegate: [optional] The session to handle the responses, if needed.
    public init(session: URLSession = .shared, delegate: HTTPSessionDelegate? = nil) {
        self.session = session
        self.sessionDelegate = delegate
    }

    // MARK: Request

    /// Creates and sends a request, fetching raw data from an endpoint.
    /// Returns a `URLSessionTask`, which allows for cancellation and retries.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request.
    /// - Parameter parameters: The dictionary of parameters to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to be with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses default for HTTP method.
    /// - Parameter completion: The completion block to call when the request is completed.
    @discardableResult
    public func request(_ url: URLConvertible,
                        method: HTTPMethod,
                        parameters: [String: Any]? = nil,
                        headers: HTTPHeaderDictionaryConvertible? = nil,
                        encoding: ParameterEncoding? = nil,
                        completion: DataTaskCompletion? = nil) -> URLSessionTask? {
        guard let request = self.configuredURLRequest(
            url: url,
            method: method,
            parameters: parameters,
            headers: headers,
            encoding: encoding
        ) else {
            completion?(.failure(UBNetworkError.unexpectedError))
            return nil
        }

        let completion: HTTPSessionDelegateCompletion = { data, urlResponse, error in
            // Convert the URLResponse into an HTTPURLResponse object.
            // If it cannot be converted, use the undefined HTTPURLResponse object
            let httpResponse = urlResponse as? HTTPURLResponse

            // Create a result object for improved handling of the response
            let result: Result<Data, Error> = {
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

            // Fire the completion!
            completion?(dataResponse)
        }

        let task: URLSessionTask
        if let delegate = self.sessionDelegate {
            delegate.completion = completion
            task = self.session.downloadTask(with: request)
        } else {
            task = self.session.dataTask(with: request, completionHandler: completion)
        }
        task.resume()

        return task
    }

    /// Creates and sends a request, fetching raw data from an endpoint that is decoded into a Decodable object.
    /// Returns a `URLSessionTask`, which allows for cancellation and retries.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request.
    /// - Parameter parameters: The dictionary of parameters to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to be with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses default for HTTP method.
    /// - Parameter jsonDecoder: The `JSONDecoder` to use when decoding the response data.
    /// - Parameter completion: The completion block to call when the request is completed.
    @discardableResult
    public func request<T>(_ url: URLConvertible,
                           method: HTTPMethod,
                           parameters: [String: Any]? = nil,
                           headers: HTTPHeaderDictionaryConvertible? = nil,
                           encoding: ParameterEncoding? = nil,
                           decoder: JSONDecoder = JSONDecoder(),
                           completion: DecodableTaskCompletion<T>? = nil) -> URLSessionTask? where T: Decodable {
        return self.request(
            url,
            method: method,
            parameters: parameters,
            headers: headers,
            encoding: encoding
        ) { dataResponse in
            // Create a result object for improved handling of the response
            let result: Result<T, Error> = {
                switch dataResponse.result {
                case let .success(data) where T.self == Data.self:
                    // If T is Data, we have nothing to decode, so just return it as-is!
                    if let data = data as? T {
                        return .success(data)
                    } else {
                        return .failure(UBNetworkError.unableToDecode(String(describing: T.self)))
                    }
                case let .success(data):
                    // TODO: Implement mime type checking for JSON before attempting to decode JSON (IOS-1967)
//                    // If the mime type for the response isn't JSON, we can't decode it
//                    guard dataResponse.response?.mimeType == "application/json" else {
//                        return .failure(UBNetworkError.invalidContentType(dataResponse.response?.mimeType ?? "unknown"))
//                    }

                    do {
                        let decodedObject = try decoder.decode(T.self, from: data)
                        return .success(decodedObject)
                    } catch {
                        return .failure(UBNetworkError.unableToDecode(String(describing: T.self)))
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

    /// Creates a configured URLRequest.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request.
    /// - Parameter parameters: The dictionary of parameters to send in the query string or HTTP body.
    /// - Parameter headers: The HTTP headers to be with the request.
    /// - Parameter encoding: The parameter encoding method. If nil, uses default for HTTP method.
    private func configuredURLRequest(url: URLConvertible,
                                      method: HTTPMethod,
                                      parameters: [String: Any]? = nil,
                                      headers: HTTPHeaderDictionaryConvertible? = nil,
                                      encoding: ParameterEncoding? = nil) -> URLRequest? {
        guard let url = try? url.asURL() else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        request.setHeaders(headers)

        // Parameters must be set after setting headers, because encoding dictates (and therefore overrides) the Content-Type header
        request.setParameters(parameters, method: method, encoding: encoding)

        return request
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
