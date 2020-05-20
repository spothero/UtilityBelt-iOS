// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension Encodable {
    func toPrettyPrintedJSON() throws -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try encoder.encode(self)
        return String(data: jsonData, encoding: .utf8)
    }
}
