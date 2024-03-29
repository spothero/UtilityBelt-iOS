// Copyright © 2023 SpotHero, Inc. All rights reserved.

import Foundation

// MARK: - Return Types

/// A tuple returned from requests that return raw data.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public typealias DataTaskSuccess = (request: URLRequest,
                                    response: HTTPURLResponse,
                                    data: Data)

/// A tuple returned from requests that return decoded objects.
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public typealias DecodableTaskSuccess<T: Decodable> = (request: URLRequest, // swiftlint:disable:this large_tuple
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

        // We capture the request and a cancellation handler here to cancel the underlying
        // request should the task get cancelled through Swift Concurrency. We use `let onCancel`
        // here so that we can capture a reference of the request in `withTaskCancellationHandler`
        // onCancel parameter.
        //
        // This nifty workaround found here: https://forums.swift.org/t/how-to-use-withtaskcancellationhandler-properly/54341/6
        var request: Request?
        let onCancel = { request?.cancel() }

        // Return a continuation wrapping a `Request`
        return try await withTaskCancellationHandler {
            return try await withCheckedThrowingContinuation { continuation in
                // The task may have already been cancelled at this point so it's always good to check...
                guard !Task.isCancelled else {
                    continuation.resume(throwing: RequestError.swiftCancellation)
                    return
                }

                request = Request(session: session,
                                  validators: validators,
                                  interceptor: interceptor,
                                  dispatchQueue: .global()) { response in
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

                request?.perform(urlRequest: urlRequest)
            }
        } onCancel: {
            onCancel()
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

// MARK: - RequestError

/// An error thrown when making a request through ``HTTPClient``
public struct RequestError: Error {
    /// The underlying error that caused the request to fail.
    public let underlyingError: Error

    /// The `HTTPURLResponse` for the request if the error occurred at a point where one might exist.
    public let response: HTTPURLResponse?

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    static let swiftCancellation = RequestError(underlyingError: CancellationError(), response: nil)
}
