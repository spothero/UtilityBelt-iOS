// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
