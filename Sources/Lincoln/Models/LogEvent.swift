// Copyright © 2020 SpotHero, Inc. All rights reserved.

// TODO: How can we make this conform Codable?
public struct LogEvent {
    public let item: Any
//    public let message: String
    public let level: Lincoln.LogLevel
//    public let error: Error?
    
    public let filePath: StaticString
    public let line: UInt
    public let column: UInt
    public let function: StaticString
    
    public init(item: Any,
                level: Lincoln.LogLevel,
                filePath: StaticString,
                line: UInt,
                column: UInt,
                function: StaticString) {
        self.item = item
        self.level = level
        self.filePath = filePath
        self.line = line
        self.column = column
        self.function = function
    }
    
    public lazy var filename: String? = {
        if let substring = "\(self.filePath)".split(separator: "/").last {
            return String(substring)
        } else {
            return nil
        }
    }()
    
    public lazy var messagePrefix: String? = {
        // If the filename is empty, there's no use returning just a line number
        guard let filename = self.filename else {
            return nil
        }
        
        // Return the filename and line number enscapsulated by brackets for readability
        return "[\(filename):\(self.line)]"
    }()
}
