// Copyright © 2023 SpotHero, Inc. All rights reserved.

import Foundation

/// A tuple returned from requests that return raw data.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public typealias DataTaskSuccess = (request: URLRequest,
                                    response: HTTPURLResponse,
                                    data: Data)

/// A tuple returned from requests that return decoded objects.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public typealias DecodableTaskSuccess<T: Decodable> = (request: URLRequest,
                                                       response: HTTPURLResponse,
                                                       data: Data,
                                                       value: T)

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public extension HTTPClient {
    // MARK: Data Response

    /// Sends a request which fetches raw data from an endpoint.
    /// - Parameters:
    ///   - request: The `URLRequest` to make the request with.
    ///   - validators: An array of validators that will be applied to the response.
    ///   - interceptor: An object that can intercept the url request. Defaults to `nil`.
    /// - Returns: The request used, the response and raw data.
    /// - Throws: A ``RequestError`` containing the thrown error and a `HTTPURLResponse` if available.
    func request(
        _ urlRequest: URLRequest,
        validators: [ResponseValidator] = [],
        interceptor: RequestInterceptor? = nil
    ) async throws -> DataTaskSuccess {
        self.logStart(of: urlRequest)

        // Get a modified request with a given timeout interval.
        let urlRequest = urlRequest.withTimeout(self.timeoutInterval)

        let request = Request(session: session,
                              validators: validators,
                              interceptor: interceptor,
                              dispatchQueue: .global())

        return try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                request.perform(urlRequest: urlRequest) { response in
                    if let underlyingError = response.error {
                        let error = RequestError(underlyingError: underlyingError, response: response.response)
                        continuation.resume(throwing: error)
                    } else if let request = response.request,
                              let httpResponse = response.response,
                              let data = response.data {
                        continuation.resume(returning: (request, httpResponse, data))
                    } else {
                        preconditionFailure("Network request failed with no error")
                    }
                }
            }
        } onCancel: {
            request.cancel()
        }
    }

    // MARK: Decodable Object Response

    /// Sends a request which fetches raw data from an endpoint and decodes it.
    /// - Parameters:
    ///   - request: The `URLRequest` to make the request with.
    ///   - validators: An array of validators that will be applied to the response. Defaults to ensuring a JSON mime type on the response.
    ///   - interceptor: An object that can intercept the url request. Defaults to `nil`.
    ///   - decoder: The `JSONDecoder` to use when decoding the response data. Defaults to `JSONDecoder()`.
    /// - Returns: The request used, the response and the raw and decoded data.
    @discardableResult
    func request<T: Decodable>(
        _ urlRequest: URLRequest,
        validators: [ResponseValidator] = [.ensureMimeType(.json)],
        interceptor: RequestInterceptor? = nil,
        decoder: JSONDecoder = .init()
    ) async throws -> DecodableTaskSuccess<T> {
        let (request, response, data) = try await request(urlRequest,
                                                          validators: validators,
                                                          interceptor: interceptor)

        // If T is Data, we have nothing to decode, so just return it as-is!
        if let value = data as? T {
            return (request, response, data, value)
        }

        // Otherwise decode the data into the requested type
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return (request, response, data, decodedObject)
        } catch let error as DecodingError {
            throw UBNetworkError.unableToDecode(String(describing: T.self), error)
        } catch {
            throw UBNetworkError.unableToDecode(String(describing: T.self), nil)
        }
    }
}

public struct RequestError: Error {
    public let underlyingError: Error
    public let response: HTTPURLResponse?
}
