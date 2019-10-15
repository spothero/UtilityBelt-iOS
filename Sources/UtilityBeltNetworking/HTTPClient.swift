// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// A completion handler for requests that return raw data results.
public typealias DataTaskCompletion = (DataResult) -> Void

/// A completion handler for requests that return decoded object results.
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

//    /// Creates and sends a request, fetching raw data from an endpoint.
//    /// - Parameter url: The URL for the request. Accepts a URL or a String.
//    /// - Parameter method: The HTTP method for the request.
//    /// - Parameter parameters: The dictionary of parameters to send in the query string or HTTP body.
//    /// - Parameter encoding: The parameter encoding method. If nil, uses default for HTTP method.
//    /// - Parameter completion: The completion block to call when the request is completed, regardless of error.
//    public func request(_ url: URLConvertible,
//                        method: HTTPMethod,
//                        parameters: [String: Any]? = nil,
//                        encoding: ParameterEncoding = .defaultEncodingForMethod) -> HTTPRequest {
////        guard let url = try? url.asURL() else {
////            // TODO: Throw error
////            return
////        }
//
//        return self.configuredRequest(url: url, method: method, parameters: parameters, encoding: encoding)
//
////        guard let request = self.configuredRequest(url: url, method: method, parameters: parameters, encoding: encoding) else {
////            // TODO: Throw error
////            return
////        }
////
////        return request
//
////        let task = self.session.dataTask(with: request) { data, response, error in
////            var result: DataResult
////
////            if let httpResponse = response as? HTTPURLResponse {
////                result = DataResult(data: data, response: httpResponse, error: error)
////            } else {
////                // TODO: Return a custom error in this block
////                assertionFailure("Unable to parse URLResponse into an HTTPURLResponse.")
////                result = DataResult(data: data, response: .undefined(url), error: UBNetworkError.invalidURLResponse)
////            }
////
////            completion?(result)
////        }
////
////        task.resume()
//    }
//
//    /// Creates and sends a request, fetching raw data from an endpoint that is decoded into a Decodable object.
//    /// - Parameter url: The URL for the request. Accepts a URL or a String.
//    /// - Parameter method: The HTTP method for the request.
//    /// - Parameter parameters: The dictionary of parameters to send in the query string or HTTP body.
//    /// - Parameter encoding: The parameter encoding method. If nil, uses default for HTTP method.
//    /// - Parameter completion: The completion block to call when the request is completed, regardless of error.
//    public func request<T>(_ url: URLConvertible,
//                           method: HTTPMethod,
//                           parameters: [String: Any]? = nil,
//                           encoding: ParameterEncoding = .defaultEncodingForMethod,
//                           completion: DecodableTaskCompletion<T>? = nil) where T: Decodable {
////        guard let url = try? url.asURL() else {
////            // TODO: Throw error
////            return
////        }
////
////        self.request(url, method: method, parameters: parameters, encoding: encoding) { rawResult in
////            // TODO: Check the response.mimeType and ensure it is application/json, which is required for decoding
////
////            // Initialize a nil decoded object to eventually pass into the DecodableResult
////            var decodedObject: T?
////
////            // If there is data in the raw result, attempt to decode it
////            if let data = rawResult.data {
////                decodedObject = try? JSONDecoder().decode(T.self, from: data)
////            }
////
////            // Create the DecodableResult object with the new decodedObject (if successfully decoded),
////            // as well as the response and status from the previous result
////            let result = DecodableResult(data: decodedObject, response: rawResult.response)
////
////            // Fire the completion handler
////            completion?(result)
////        }
//    }

    /// Creates and configures HTTPRequest.
    /// - Parameter url: The URL for the request.
    /// - Parameter method: The HTTP method for the request.
    /// - Parameter headers: The HTTP headers for the request.
    /// - Parameter parameters: The dictionary of parameters to send in the query string or HTTP body.
    /// - Parameter encoding: The parameter encoding method. If nil, uses default for HTTP method.
    public func request(url: URLConvertible,
                        method: HTTPMethod = .get,
                        headers: [String: String] = [:],
                        parameters: [String: Any]? = nil,
                        encoding: ParameterEncoding = .defaultEncodingForMethod) -> HTTPRequest {
        let request = HTTPRequest(url: url, delegate: self)
            .method(method)
            .headers(headers)
            .parameters(parameters)
            .parameterEncoding(encoding)
        
        return request
    }
}

extension HTTPClient: HTTPRequesting {
    public func response(for request: URLRequestConvertible, completion: DataTaskCompletion? = nil) {
        do {
            let request = try request.asURLRequest()
            
            let task = self.session.dataTask(with: request) { data, response, error in
                var result: DataResult
                
                if let httpResponse = response as? HTTPURLResponse {
                    result = DataResult(data: data, response: httpResponse, error: error)
                } else {
                    // TODO: Return a custom error in this block
                    assertionFailure("Unable to parse URLResponse into an HTTPURLResponse.")
                    // TODO: Don't return an empty response?
                    result = DataResult(data: data, response: .undefined(request.url!), error: UBNetworkError.invalidURLResponse)
                }
                
                completion?(result)
            }
            
            task.resume()
        } catch {
            // TODO: Fire off a completion with an error
        }
    }
    
    public func response<T>(for request: URLRequestConvertible, completion: DecodableTaskCompletion<T>? = nil) {
        self.response(for: request) { dataResult in
            // TODO: Check the response.mimeType and ensure it is application/json, which is required for decoding
            
            // Initialize a nil decoded object to eventually pass into the DecodableResult
            var decodedObject: T?
            
            // If there is data in the raw result, attempt to decode it
            if let data = dataResult.data {
                decodedObject = try? JSONDecoder().decode(T.self, from: data)
            }
            
            // Create the DecodableResult object with the new decodedObject (if successfully decoded),
            // as well as the response and status from the previous result
            let result = DecodableResult(data: decodedObject, response: dataResult.response)
            
            // Fire the completion handler
            completion?(result)
        }
    }
}
