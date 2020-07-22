// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any]? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(self)
        
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
