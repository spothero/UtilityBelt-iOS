// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public typealias DataTaskCompletion = (DataResult) -> Void
public typealias DecodableTaskCompletion<T> = (DecodableResult<T>) -> Void where T: Decodable

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
    /// - Parameter url: The URL for the request.
    /// - Parameter method: The HTTP method for the request.
    /// - Parameter parameters: The dictionary of parameters to send in the query string or HTTP body.
    /// - Parameter encoding: The parameter encoding method. If nil, uses default for HTTP method.
    /// - Parameter completion: The completion block to call when the request is completed, regardless of error.
    public func request(_ url: URL,
                        method: HTTPMethod,
                        parameters: [String: Any]? = nil,
                        encoding: ParameterEncoding? = nil,
                        completion: DataTaskCompletion? = nil) {
        guard let request = self.configuredURLRequest(url: url, method: method, parameters: parameters, encoding: encoding) else {
            // TODO: Throw error
            return
        }

        let task = self.session.dataTask(with: request) { data, response, error in
//            guard let mimeType = response.mimeType, mimeType == "application/json" else {
//                print("Wrong MIME type!")
//                return
//            }

            let result = DataResult(data: data, response: response, error: error)
            completion?(result)
        }

        task.resume()
    }

    /// Creates and sends a request, fetching raw data from an endpoint that is decoded into a Decodable object.
    /// - Parameter url: The URL for the request.
    /// - Parameter method: The HTTP method for the request.
    /// - Parameter parameters: The dictionary of parameters to send in the query string or HTTP body.
    /// - Parameter encoding: The parameter encoding method. If nil, uses default for HTTP method.
    /// - Parameter completion: The completion block to call when the request is completed, regardless of error.
    public func request<T>(_ url: URL,
                           method: HTTPMethod,
                           parameters: [String: Any]? = nil,
                           encoding: ParameterEncoding? = nil,
                           completion: DecodableTaskCompletion<T>? = nil) where T: Decodable {
        self.request(url, method: method, parameters: parameters, encoding: encoding) { rawResult in
            // Initialize a nil decoded object to eventually pass into the DecodableResult
            var decodedObject: T?

            // If there is data in the raw result, attempt to decode it
            if let data = rawResult.data {
                decodedObject = try? JSONDecoder().decode(T.self, from: data)
            }

            // Create the DecodableResult object with the new decodedObject (if successfully decoded),
            // as well as the response and status from the previous result
            let result = DecodableResult(data: decodedObject, response: rawResult.response, status: rawResult.status)

            // Fire the completion handler
            completion?(result)
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
