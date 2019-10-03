// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

extension Dictionary {
    func asJSONSerializedData() throws -> Data {
        if #available(OSX 10.13, *) {
            return try JSONSerialization.data(withJSONObject: self, options: .sortedKeys)
        } else {
            return try JSONSerialization.data(withJSONObject: self, options: [])
        }
    }
}
