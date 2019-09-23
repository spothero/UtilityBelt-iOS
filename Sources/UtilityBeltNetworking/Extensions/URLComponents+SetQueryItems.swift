// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: Any]) {
        self.queryItems = parameters.flatMap { self.evaluatedQueryItems(for: $0) }
    }
    
    private func evaluatedQueryItems(for parameter: (key: String, value: Any)) -> [URLQueryItem] {
        switch parameter.value {
        case let dictionary as [String: Any]:
            return dictionary.flatMap {
                self.evaluatedQueryItems(for: ("\(parameter.key)[\($0)]", $1))
            }
        case let array as [Any]:
            // TODO: Allow encoding of arrays without brackets (and as comma-delimited list?)
            return array.flatMap {
                self.evaluatedQueryItems(for: ("\(parameter.key)[]", $0))
            }
        case let bool as Bool:
            // TODO: Allow encoding of bools as numbers
            return [URLQueryItem(name: parameter.key, value: "\(bool)")]
        case let value:
            return [URLQueryItem(name: parameter.key, value: String(describing: value))]
        }
    }
}
