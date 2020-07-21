// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Combine
import Foundation

@available(iOS 13, macOS 10.15, tvOS 13.0, watchOS 6, *)
extension HTTPClient {
    func requestPublisher(_ url: URLConvertible,
                          method: HTTPMethod,
                          parameters: [String: Any]? = nil,
                          headers: HTTPHeaderDictionaryConvertible? = nil,
                          encoding: ParameterEncoding? = nil) -> AnyPublisher<Data, Error> {
        let request: URLRequest
        
        do {
            request = try self.configuredURLRequest(
                url: url,
                method: method,
                parameters: parameters,
                headers: headers,
                encoding: encoding
            )
        } catch {
            return Result<Data, Error>.Publisher(error).eraseToAnyPublisher()
        }
        
        if self.isDebugLoggingEnabled, let urlString = request.url?.absoluteString {
            self.log("Starting \(method.rawValue) request to \(urlString)...")
        }
        
        return self.session
            .dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                self.log("Request finished.")
                
                self.log("[Response] \(element.response)")
                
                // Convert the URLResponse into an HTTPURLResponse object.
                // If it cannot be converted, use the undefined HTTPURLResponse object
                let httpResponse = element.response as? HTTPURLResponse
                let status = httpResponse?.status
                
                if status?.responseType == .clientError || status?.responseType == .serverError {
                    // TODO: Update with better error
                    throw UBNetworkError.unexpectedError
                }
                
                // Attempt to lob the data as pretty printed JSON, otherwise just encode to utf8
                if self.isDebugLoggingEnabled,
                    let dataString: String = element.data.asPrettyPrintedJSON ?? String(data: element.data, encoding: .utf8) {
                    self.log(dataString)
                }
                
                return element.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func requestPublisher<T: Decodable>(_ url: URLConvertible,
                                        method: HTTPMethod,
                                        parameters: [String: Any]? = nil,
                                        headers: HTTPHeaderDictionaryConvertible? = nil,
                                        encoding: ParameterEncoding? = nil,
                                        decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return self.requestPublisher(url, method: method, parameters: parameters, headers: headers, encoding: encoding)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                switch error {
                case let error as DecodingError:
                    return UBNetworkError.unableToDecode(String(describing: T.self), error)
                default:
                    return error
                }
            }
            .eraseToAnyPublisher()
    }
}
