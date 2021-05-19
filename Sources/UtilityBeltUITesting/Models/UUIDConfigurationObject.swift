// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public struct UUIDConfigurationObject: Codable {
    // MARK: Properties
    
    /// The UUID source to freeze with the given value.
    public let source: Source
    
    /// The value to store in the source UUID.
    public let value: UUID?
    
    // MARK: Initialization
    
    public init(source: Source, value: UUID?) {
        self.source = source
        self.value = value
    }
}

public extension UUIDConfigurationObject {
    enum Source: String, Codable {
        case deviceId
        case session
        case search
        case none
    }
}
