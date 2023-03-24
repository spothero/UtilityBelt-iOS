// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

@available(iOS 13.0.0, *)
public typealias DataTaskSuccess = (request: URLRequest,
                                    response: HTTPURLResponse,
                                    data: Data)

@available(iOS 13.0.0, *)
public typealias DecodableTaskSuccess<T: Decodable> = (request: URLRequest,
                                                       response: HTTPURLResponse,
                                                       data: Data,
                                                       value: T)

@available(iOS 13.0.0, *)
extension HTTPClient {
    // MARK: Data Response

    /// Creates and sends a request which fetches raw data from an endpoint.
    /// - Parameter request: The `URLRequest` to make the request with.
    /// - Parameter validators: An array of validators that will be applied to the response.
    /// - Parameter interceptor: An object that can intercept the url request. Defaults to `nil`.
    /// - Returns: The configured `Request` object that is performed upon execution of this method.
    public func request(
        _ urlRequest: URLRequest,
        validators: [ResponseValidator] = [],
        interceptor: RequestInterceptor? = nil
    ) async throws -> DataTaskSuccess {
        self.logStart(of: urlRequest)

        // Get a modified request with a given timeout interval.
        let urlRequest = urlRequest.withTimeout(self.timeoutInterval)

        return try await withCheckedThrowingContinuation { [session] continuation in
            Request(session: session,
                    validators: validators,
                    interceptor: interceptor) { response in
                if let error = response.error {
                    continuation.resume(throwing: error)
                } else if let request = response.request,
                          let httpResponse = response.response,
                          let data = response.data {
                    continuation.resume(returning: (request, httpResponse, data))
                } else {
                    preconditionFailure("Network request failed with no error")
                }
            }.perform(urlRequest: urlRequest)
        }
    }

    // MARK: Decodable Object Response

    /// Creates and sends a request which fetches raw data from an endpoint and decodes it.
    /// - Parameter request: The `URLRequest` to make the request with.
    /// - Parameter validators: An array of validators that will be applied to the response. Defaults to ensuring a JSON mime type on the response.
    /// - Parameter interceptor: An object that can intercept the url request. Defaults to `nil`.
    /// - Parameter decoder: The `JSONDecoder` to use when decoding the response data. Defaults to `JSONDecoder()`.
    /// - Returns: The configured `Request` object that is performed upon execution of this method.
    @discardableResult
    public func request<T: Decodable>(
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
