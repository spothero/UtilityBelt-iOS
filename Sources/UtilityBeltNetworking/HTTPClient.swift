// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public typealias DataTaskCompletion = (DataResult) -> Void
public typealias DecodableTaskCompletion<T> = (DecodableResult<T>) -> Void where T: Decodable
//typealias RequestCompletion = (HTTPResult) -> Void
//
// public enum HTTPResult {
//    case data(data: Data, response: URLResponse)
//    case error(error: Error, response: URLResponse)
// }

public protocol HTTPResult {
    associatedtype DataType

    var data: DataType? { get set }
    var response: URLResponse? { get set }
    var success: Bool { get }
    var error: Error? { get set }
}

public extension HTTPResult {
    var success: Bool {
        return self.data != nil && self.error == nil
    }
}

public struct DataResult: HTTPResult {
    public var data: Data?
    public var response: URLResponse?
    public var error: Error?
}

public struct DecodableResult<T>: HTTPResult where T: Decodable {
    public var data: T?
    public var response: URLResponse?
    public var error: Error?
}

public class HTTPClient {
    // MARK: - Shared Instance

    public static let shared = HTTPClient()

    // MARK: - Properties

    private let session: URLSession

    // MARK: - Methods

    // MARK: Initializers

    public init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: Request

    public func request<T>(_ url: URL,
                           method: HTTPMethod,
                           parameters: [String: Any]? = nil,
                           encoding: ParameterEncoding? = nil,
                           completion: DecodableTaskCompletion<T>? = nil) where T: Decodable {
        self.request(url, method: method, parameters: parameters, encoding: encoding) { rawResult in
            guard let data = rawResult.data, let decodedObject = try? JSONDecoder().decode(T.self, from: data) else {
                completion?(DecodableResult(data: nil, response: rawResult.response, error: rawResult.error))
                return
            }

            completion?(DecodableResult(data: decodedObject, response: rawResult.response, error: rawResult.error))
        }
    }

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
