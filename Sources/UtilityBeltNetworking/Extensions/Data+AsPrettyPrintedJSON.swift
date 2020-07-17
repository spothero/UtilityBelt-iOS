// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension Data {
    var asPrettyPrintedJSON: String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
}
