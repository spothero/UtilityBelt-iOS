// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public struct PrintLogHandler: LogHandler, LogPrinting {
    // MARK: Type Aliases
    
    public typealias LogOptions = Set<LogOption>
    
    // MARK: Enums
    
    public enum LogOption: Int, Option, Codable, CaseIterable {
        case includePrefix
        case prettyPrinted
    }
    
    // MARK: Properties
    
    /// Any global log options that should be applied to all log events.
    /// Only the `.includePrefix` option is included by default.
    public let options: LogOptions
    
    // MARK: Methods
    
    public init(options: LogOptions = [.includePrefix]) {
        self.options = options
    }
    
    public func log(_ event: LogEvent) {
        // Clean the base message any way we need to
        var message = self.message(for: event)
        
        // If there is a prefix, prepend it to the message
        if let prefix = self.prefix(for: event) {
            message = "\(prefix) \(message)"
        }
        
        // Print the message
        print(message)
    }
    
    private func message(for event: LogEvent) -> String {
        guard self.options.contains(.prettyPrinted) else {
            return String(describing: event.item)
        }
        
        return self.prettyPrintedMessage(for: event)
    }
    
    private func prefix(for event: LogEvent) -> String? {
        guard self.options.contains(.includePrefix) else {
            return nil
        }
        
        return self.messagePrefix(for: event)
    }
}
