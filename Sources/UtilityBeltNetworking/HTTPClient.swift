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
    
    public let session: URLSession
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: Request
    
    public func request<T>(_ url: URL, method: HTTPMethod, completion: DecodableTaskCompletion<T>? = nil) where T: Decodable {
        self.request(url, method: method) { rawResult in
            guard let data = rawResult.data, let decodedObject = try? JSONDecoder().decode(T.self, from: data) else {
                completion?(DecodableResult(data: nil, response: rawResult.response, error: rawResult.error))
                return
            }
            
            completion?(DecodableResult(data: decodedObject, response: rawResult.response, error: rawResult.error))
        }
    }
    
    public func request(_ url: URL, method: HTTPMethod, completion: DataTaskCompletion? = nil) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let task = self.session.dataTask(with: request) { data, response, error in
            let result = DataResult(data: data, response: response, error: error)
            completion?(result)
        }
        
        task.resume()
    }
    
    // MARK: Request Convenience
    
    //    public func request(_ urlString: String, method: HTTPMethod) {
    //        guard let url = URL(string: urlString) else {
    //            return
    //        }
    //
    //        return self.request(url, method: method)
    //    }
    
    public func get(_ url: URL) {
        self.request(url, method: .get)
    }
}
