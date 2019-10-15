// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

extension URLRequest {
    // TODO: Drop the requirement of this function. The problem is that we need one function for if the method is set,
    //       and another if the method is unset. We can refactor this, just need to determine the right way.
    //
    //       Examples:
    //       1, method without encoding: Use the default method's encoding.
    //       2. method with encoding: Use the method, but override the encoding.
    //       3. encoding without method: Doesn't matter what method, override the encoding.
    mutating func setParameters(_ parameters: [String: Any]?, method: HTTPMethod, encoding: ParameterEncoding = .defaultEncodingForMethod) {
        guard let url = self.url, let parameters = parameters else {
            return
        }
        
        // If encoding is `defaultEncodingForMethod`, resolve it to a proper encoding type
        let encoding = encoding.resolvedEncoding(for: method)

        switch encoding {
        case .defaultEncodingForMethod:
            // This should never occur
            break
        case .httpBody(.json):
            self.setValue("application/json", forHTTPHeaderField: .contentType)

            do {
                self.httpBody = try parameters.asJSONSerializedData()
            } catch {
                // TODO: Throw error?
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

    mutating func setParameters(_ encodable: Encodable, method: HTTPMethod, encoding: ParameterEncoding = .defaultEncodingForMethod) {
        let parameters = encodable.asParameters()
        self.setParameters(parameters, method: method, encoding: encoding)
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
