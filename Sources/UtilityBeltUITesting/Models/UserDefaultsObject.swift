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
            case bool
            case data
            case date
            case int
            case string
        }
        
        // MARK: Cases
        
        case bool(Bool)
        case data(Data)
        case date(Date)
        case int(Int)
        case string(String)
        
        // MARK: Decoding
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            guard let key = container.allKeys.first else {
                let debugDescription = "Container should have 1 key but none were found."
                let context = DecodingError.Context(codingPath: container.codingPath,
                                                    debugDescription: debugDescription)
                throw DecodingError.dataCorrupted(context)
            }
            
            switch key {
            case .bool:
                let value = try container.decode(Bool.self, forKey: .bool)
                self = .bool(value)
            case .data:
                let value = try container.decode(Data.self, forKey: .data)
                self = .data(value)
            case .date:
                let value = try container.decode(Date.self, forKey: .date)
                self = .date(value)
            case .int:
                let value = try container.decode(Int.self, forKey: .int)
                self = .int(value)
            case .string:
                let value = try container.decode(String.self, forKey: .string)
                self = .string(value)
            }
        }
        
        // MARK: Encoding
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case let .bool(value):
                try container.encode(value, forKey: .bool)
            case let .data(value):
                try container.encode(value, forKey: .data)
            case let .date(value):
                try container.encode(value, forKey: .date)
            case let .int(value):
                try container.encode(value, forKey: .int)
            case let .string(value):
                try container.encode(value, forKey: .string)
            }
        }
    }
}

// MARK: - UserDefaultsObject.Value + Equatable

extension UserDefaultsObject.Value: Equatable {
    public static func == (lhs: UserDefaultsObject.Value, rhs: UserDefaultsObject.Value) -> Bool {
        switch (lhs, rhs) {
        case let (.bool(leftBool), .bool(rightBool)):
            return leftBool == rightBool
        case let (.date(leftDate), .date(rightDate)):
            return leftDate == rightDate
        case let (.data(leftData), .data(rightData)):
            return leftData == rightData
        case let (.int(leftInt), .int(rightInt)):
            return leftInt == rightInt
        case let (.string(leftString), .string(rightString)):
            return leftString == rightString
        default:
            return false
        }
    }
}
