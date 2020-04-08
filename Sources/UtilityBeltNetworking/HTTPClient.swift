// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

/// A completion handler for requests that return raw data results.
public typealias DataTaskCompletion = (DataResponse<Data, Error>) -> Void

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

    // MARK: - Methods

    // MARK: Initializers

    /// Initializes a new HTTPClient with a given URLSession.
    /// - Parameter session: The URLSession to use for all requests.
    public init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: Request

    /// Creates and sends a request, fetching raw data from an endpoint.
    /// Returns a `URLSessionTask`, which allows for cancellation and retries. 
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request.
    /// - Parameter parameters: The dictionary of parameters to send in the query string or HTTP body.
    /// - Parameter encoding: The parameter encoding method. If nil, uses default for HTTP method.
    /// - Parameter completion: The completion block to call when the request is completed, regardless of error.
    @discardableResult
    public func request(_ url: URLConvertible,
                        method: HTTPMethod,
                        parameters: [String: Any]? = nil,
                        encoding: ParameterEncoding? = nil,
                        completion: DataTaskCompletion? = nil) -> URLSessionTask? {
        guard let url = try? url.asURL() else {
            // TODO: Throw error
            return nil
        }

        guard let request = self.configuredURLRequest(url: url, method: method, parameters: parameters, encoding: encoding) else {
            // TODO: Throw error
            return nil
        }

        let task = self.session.dataTask(with: request) { data, urlResponse, error in
            // Convert the URLResponse into an HTTPURLResponse object.
            // If it cannot be converted, use the undefined HTTPURLResponse object
            let httpResponse = (urlResponse as? HTTPURLResponse) ?? .undefined(url)

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

        task.resume()
        
        return task
    }

    /// Creates and sends a request, fetching raw data from an endpoint that is decoded into a Decodable object.
    /// Returns a `URLSessionTask`, which allows for cancellation and retries.
    /// - Parameter url: The URL for the request. Accepts a URL or a String.
    /// - Parameter method: The HTTP method for the request.
    /// - Parameter parameters: The dictionary of parameters to send in the query string or HTTP body.
    /// - Parameter encoding: The parameter encoding method. If nil, uses default for HTTP method.
    /// - Parameter completion: The completion block to call when the request is completed, regardless of error.
    @discardableResult
    public func request<T>(_ url: URLConvertible,
                           method: HTTPMethod,
                           parameters: [String: Any]? = nil,
                           encoding: ParameterEncoding? = nil,
                           completion: DecodableTaskCompletion<T>? = nil) -> URLSessionTask? where T: Decodable {
        guard let url = try? url.asURL() else {
            // TODO: Throw error
            return nil
        }

        return self.request(url, method: method, parameters: parameters, encoding: encoding) { dataResponse in
            // TODO: Check the response.mimeType and ensure it is application/json, which is required for decoding

            // Create a result object for improved handling of the response
            let result: Result<T, Error> = {
                switch dataResponse.result {
                case let .success(data):
                    if let decodedObject = try? JSONDecoder().decode(T.self, from: data) {
                        return .success(decodedObject)
                    } else {
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
    /// - Parameter url: The URL for the request.
    /// - Parameter method: The HTTP method for the request.
    /// - Parameter parameters: The dictionary of parameters to send in the query string or HTTP body.
    /// - Parameter encoding: The parameter encoding method. If nil, uses default for HTTP method.
    private func configuredURLRequest(url: URL,
                                      method: HTTPMethod,
                                      parameters: [String: Any]? = nil,
                                      encoding: ParameterEncoding? = nil) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        request.setParameters(parameters, method: method, encoding: encoding)

        return request
    }
}
