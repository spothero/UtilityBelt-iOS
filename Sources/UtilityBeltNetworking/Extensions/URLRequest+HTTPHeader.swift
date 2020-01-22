// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension URLRequest {
    mutating func setValue(_ value: String?, forHTTPHeaderField field: HTTPHeader) {
        self.setValue(value, forHTTPHeaderField: field.rawValue)
    }
}
