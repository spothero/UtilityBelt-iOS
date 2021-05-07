// Copyright © 2021 SpotHero, Inc. All rights reserved.

public protocol ParameterDictionaryConvertible {
    func asParameterDictionary() -> [String: Any]?
}

public extension ParameterDictionaryConvertible where Self: Encodable {
    func asParameterDictionary() -> [String: Any]? {
        return try? self.asDictionary()
    }
}

extension Dictionary: ParameterDictionaryConvertible where Key == String, Value == Any {
    public func asParameterDictionary() -> [String: Any]? {
        return self
    }
}
