// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

extension URLRequest {
    mutating func setParameters(_ parameters: [String: Any]?, method: HTTPMethod, encoding: ParameterEncoding? = nil) {
        let encoding = encoding ?? method.defaultParameterEncoding
        self.setParameters(parameters, encoding: encoding)
    }

    mutating func setParameters(_ parameters: [String: Any]?, encoding: ParameterEncoding) {
        guard let url = self.url, let parameters = parameters else {
            return
        }

        switch encoding {
        case .httpBody(.json):
            self.setValue("application/json", forHTTPHeaderField: .contentType)
            
            do {
                self.httpBody = try parameters.asJSONSerializedData()
            } catch {
                // TODO: Throw error
            }
        case .httpBody(.wwwFormURLEncoded):
            self.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: .contentType)
            
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.setQueryItems(with: parameters)
            
            self.httpBody = urlComponents?.percentEncodedQuery?.data(using: .utf8)
        case .queryString:
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.setQueryItems(with: parameters)

            self.url = urlComponents?.url
        }
    }
    
    mutating func setParameters(_ encodable: Encodable, method: HTTPMethod, encoding: ParameterEncoding? = nil) {
        let parameters = encodable.asParameters()
        self.setParameters(parameters, method: method, encoding: encoding)
    }
    
    mutating func setParameters(_ encodable: Encodable, encoding: ParameterEncoding) {
        let parameters = encodable.asParameters()
        self.setParameters(parameters, encoding: encoding)
    }
}

private extension Encodable {
    func asParameters() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        let decodedData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        return decodedData.flatMap { $0 as? [String: Any] }
    }
}
