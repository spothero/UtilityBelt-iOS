// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public struct MimeType: RawRepresentable, Codable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let json: Self = MimeType(rawValue: "application/json")
}
