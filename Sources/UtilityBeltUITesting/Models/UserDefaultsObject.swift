// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public struct UserDefaultsObject: Codable {
    // MARK: Properties
    
    /// The key used to represent the `value` in `UserDefaults`.
    public let key: String
    
    /// The value to store in `UserDefaults` under the `key`.
    public let value: Value
    
    // MARK: Initialization
    
    public init(key: String, value: Value) {
        self.key = key
        self.value = value
    }
}

// MARK: - Equatable

extension UserDefaultsObject: Equatable {}

// MARK: - UserDefaultsObject.Value

public extension UserDefaultsObject {
    enum Value: Codable {
        // MARK: CodingKeys
        
        enum CodingKeys: String, CodingKey {
            case date
            case int
            case object
        }
        
        // MARK: Cases
        
        case date(Date)
        case int(Int)
        indirect case object(UserDefaultsObject)
        case `nil`
        
        // MARK: Decoding
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            switch container.allKeys.first {
            case .date:
                let value = try container.decode(Date.self, forKey: .date)
                self = .date(value)
            case .int:
                let value = try container.decode(Int.self, forKey: .int)
                self = .int(value)
            case .object:
                let value = try container.decode(UserDefaultsObject.self, forKey: .object)
                self = .object(value)
            case nil:
                self = .nil
            }
        }
        
        // MARK: Encoding
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case let .date(value):
                try container.encode(value, forKey: .date)
            case let .int(value):
                try container.encode(value, forKey: .int)
            case let .object(value):
                try container.encode(value, forKey: .object)
            case .nil:
                break
            }
        }
    }
}

// MARK: - UserDefaultsObject.Value + Equatable

extension UserDefaultsObject.Value: Equatable {
    public static func == (lhs: UserDefaultsObject.Value, rhs: UserDefaultsObject.Value) -> Bool {
        switch (lhs, rhs) {
        case let (.date(leftDate), .date(rightDate)):
            return leftDate == rightDate
        case let (.int(leftInt), .int(rightInt)):
            return leftInt == rightInt
        case let (.object(leftObject), .object(rightObject)):
            return leftObject == rightObject
        case (.nil, .nil):
            return true
        default:
            return false
        }
    }
}
