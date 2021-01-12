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
            case double
            case float
            case int
            case string
            case uint
        }
        
        // MARK: Cases
        
        case bool(Bool)
        case data(Data)
        case date(Date)
        case double(Double)
        case float(Float)
        case int(Int)
        case string(String)
        case uint(UInt)
        
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
            case .double:
                let value = try container.decode(Double.self, forKey: .double)
                self = .double(value)
            case .float:
                let value = try container.decode(Float.self, forKey: .float)
                self = .float(value)
            case .int:
                let value = try container.decode(Int.self, forKey: .int)
                self = .int(value)
            case .string:
                let value = try container.decode(String.self, forKey: .string)
                self = .string(value)
            case .uint:
                let value = try container.decode(UInt.self, forKey: .uint)
                self = .uint(value)
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
            case let .double(value):
                try container.encode(value, forKey: .double)
            case let .float(value):
                try container.encode(value, forKey: .float)
            case let .int(value):
                try container.encode(value, forKey: .int)
            case let .string(value):
                try container.encode(value, forKey: .string)
            case let .uint(value):
                try container.encode(value, forKey: .uint)
            }
        }
    }
}

// MARK: - UserDefaultsObject.Value + Equatable

extension UserDefaultsObject.Value: Equatable {
    public static func == (lhs: UserDefaultsObject.Value, rhs: UserDefaultsObject.Value) -> Bool {
        switch (lhs, rhs) {
        case let (.bool(leftValue), .bool(rightValue)):
            return leftValue == rightValue
        case let (.date(leftValue), .date(rightValue)):
            return leftValue == rightValue
        case let (.data(leftValue), .data(rightValue)):
            return leftValue == rightValue
        case let (.double(leftValue), .double(rightValue)):
            return leftValue == rightValue
        case let (.float(leftValue), .float(rightValue)):
            return leftValue == rightValue
        case let (.int(leftValue), .int(rightValue)):
            return leftValue == rightValue
        case let (.string(leftValue), .string(rightValue)):
            return leftValue == rightValue
        case let (.uint(leftValue), .uint(rightValue)):
            return leftValue == rightValue
        default:
            return false
        }
    }
}
