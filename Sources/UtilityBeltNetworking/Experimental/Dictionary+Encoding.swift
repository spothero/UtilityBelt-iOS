
//public extension Dictionary where Key == String {
//    func asQueryString() -> String {
//        // We want to make an array of tuples, not a dictionary
//        // to allow for APIs that accept array parameters by repeating keys instead of adding square brackets
//        var parameters: [(String, String)] = []
//
//        for key in self.keys.sorted(by: <) {
//            guard let value = self[key] else {
//                continue
//            }
//
//            parameters += self.queryComponents(key: key, value: value)
//        }
//
//        return parameters.map { "\($0)=\($1)" }.joined(separator: "&")
//    }
//
//    /// Creates a percent-escaped string following RFC 3986 for a query string key or value.
//    ///
//    /// - Parameter string: `String` to be percent-escaped.
//    ///
//    /// - Returns:          The percent-escaped `String`.
//    private func escape(_ string: String) -> String {
//        return string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
//    }
//
//    /// Creates a percent-escaped, URL encoded query string components from the given key-value pair recursively.
//    ///
//    /// - Parameters:
//    ///   - key:   Key of the query component.
//    ///   - value: Value of the query component.
//    ///
//    /// - Returns: The percent-escaped, URL encoded query string components.
//    func queryComponents(key: String, value: Any) -> [(String, String)] {
//        var components: [(String, String)] = []
//
//        let arrayEncoding: ArrayEncoding = .brackets
//        let boolEncoding: BoolEncoding = .numeric
//
//        switch value {
//        case let dictionary as [String: Any]:
//            for (nestedKey, value) in dictionary {
//                components += self.queryComponents(key: "\(key)[\(nestedKey)]", value: value)
//            }
//        case let array as [Any]:
//            for value in array {
//                components += self.queryComponents(key: arrayEncoding.encode(key: key), value: value)
//            }
//        case let number as NSNumber:
//            if number.isBool {
//                components.append((self.escape(key), self.escape(boolEncoding.encode(value: number.boolValue))))
//            } else {
//                components.append((self.escape(key), self.escape("\(number)")))
//            }
//        case let bool as Bool:
//            components.append((self.escape(key), self.escape(boolEncoding.encode(value: bool))))
//        default:
//            components.append((self.escape(key), self.escape("\(value)")))
//        }
//
//        return components
//    }
//
//    /// Configures how `Array` parameters are encoded.
//    enum ArrayEncoding {
//        /// An empty set of square brackets is appended to the key for every value. This is the default behavior.
//        case brackets
//        /// No brackets are appended. The key is encoded as is.
//        case noBrackets
//
//        func encode(key: String) -> String {
//            switch self {
//            case .brackets:
//                return "\(key)[]"
//            case .noBrackets:
//                return key
//            }
//        }
//    }
//
//    /// Configures how `Bool` parameters are encoded.
//    enum BoolEncoding {
//        /// Encode `true` as `1` and `false` as `0`. This is the default behavior.
//        case numeric
//        /// Encode `true` and `false` as string literals.
//        case literal
//
//        func encode(value: Bool) -> String {
//            switch self {
//            case .numeric:
//                return value ? "1" : "0"
//            case .literal:
//                return value ? "true" : "false"
//            }
//        }
//    }
//}

//extension NSNumber {
//    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
//}
