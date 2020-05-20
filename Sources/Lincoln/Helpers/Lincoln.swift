// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public class Lincoln {
    // MARK: Type Aliases
    
    public typealias LogOptions = Set<Lincoln.LogOption>
    
    // MARK: Shared Instance
    
    public static let shared = Lincoln()
    
    // MARK: Enums
    
    /// The log level.
    ///
    /// Log levels are ordered by their severity, with `.trace` being the least severe and
    /// `.critical` being the most severe.
    ///
    /// Sources:
    /// - [RFC 5424](https://tools.ietf.org/html/rfc5424#page-11)
    /// - [swift-log](https://github.com/apple/swift-log/blob/87c2553da204fc269be89aec39e38217d65c4980/Sources/Logging/Logging.swift#L325)
    public enum LogLevel: Int, Codable {
        /// Indicates a critical error condition that requires immediate attention.
        case critical = 0
        /// Indicates an error condition that requires attention.
        case error = 1
        /// Indicates a warning condition that might need to be tracked.
        case warning = 2
        /// Indicates an event that might require special handling.
        case notice = 3
        /// Indicates an informational message.
        case info = 4
        /// Indicates a message used to debug a program.
        case debug = 5
        /// Indicates a message used to trace the execution of a program.
        case trace = 6
    }
    
    public enum LogOption: Int, Option, Codable {
        case includeFileAndLineNumber
        case prettyPrinted
    }
    
    // MARK: Properties
    
    /// The least severe log level that Lincoln should process log events for.
    public var logLevel: LogLevel = .trace
    
    /// The handlers to use for processing log events. A handler must be registered for logs to be processed.
    /// There is no guaranteed order that the handlers will be called in.
    ///
    /// To get started, call `registerHandler(PrintLogHandler())`.
    private var handlers: [LogHandler] = []
    
    /// Any global log options that should be applied to all log events.
    /// The default options will log file and line numbers that all events occur on.
    public var logOptions: LogOptions = [.includeFileAndLineNumber]
    
    // MARK: Methods - Logging
    
    // TODO: Update log to process multiple items.
    
    /// Logs information for the given item.
    ///
    /// - Parameters:
    ///   - item: The item to log information about.
    ///   - level: The severity of the log event. Defaults to `.info`, indicating an informational log.
    ///   - options: Additional options to be applied to this log call. Combines with any global options.
    ///   - file: The file that called this method.
    ///   - line: The line that this method was called on.
    ///   - column: The column that called this method was called on.
    ///   - function: The function that this method was called within.
    public func log(_ item: Any,
                    level: LogLevel = .info,
                    options: LogOptions = [],
                    file: StaticString = #file,
                    line: UInt = #line,
                    column: UInt = #column,
                    function: StaticString = #function) {
        // Only process logs if the current log level is higher (ie. less severe) than the current log event's level
        guard level.rawValue <= self.logLevel.rawValue else {
            return
        }
        
        // We also shouldn't do anything if there are no handlers registered
        guard !self.handlers.isEmpty else {
            return
        }
        
        // Get a set of log options containing the global options as well as the additional options for this call
        let allOptions = self.logOptions.union(options)
        
        // Clean the base message any way we need to.
        var message = self.message(for: item, level: level, options: allOptions, file: file, line: line)
        
        // If there is a prefix, prepend it to the message
        if let prefix = self.messagePrefix(for: item, level: level, options: allOptions, file: file, line: line) {
            message = "\(prefix) \(message)"
        }
        
        // Create a log event object for ease of passing around
        let event = LogEvent(item: item,
                             message: message,
                             level: level,
                             options: allOptions,
                             file: "\(file)",
                             line: line,
                             column: column,
                             function: "\(file)")
        
        // Finally, send the log events to the registered handlers
        self.handlers.forEach { $0.log(event) }
    }
    
    // TODO: Consider wrapping the error here if a message is supplied, then passing it into the log function.
    
    // swiftlint:disable:next function_parameter_count
    private func report(_ error: Error,
                        message: String?,
                        level: LogLevel,
                        options: LogOptions,
                        file: StaticString,
                        line: UInt,
                        column: UInt,
                        function: StaticString) {
        // Attempt to clean up the error message if we need to
        let errorMessage: String = {
            if let decodingError = error as? DecodingError {
                return decodingError.cleanedDescription
            } else {
                return error.localizedDescription
            }
        }()
        
        // If there was an explicit message provided, format them such that the
        // error is appended to the explicit message.
        let logMessage: String = {
            if let message = message {
                return "\(message) (\(errorMessage))"
            } else {
                return errorMessage
            }
        }()
        
        self.log(logMessage, level: level, options: options, file: file, line: line)
    }
    
    // MARK: Methods - Measuring
    
//    @discardableResult
//    func measure(_ closure: () -> Void) -> TimeInterval? {
//        // If debugging is not enabled, just fire the closure immediately
//        guard isDebugEnabled else {
//            closure()
//            return nil
//        }
//
//        // Start the stopwatch
//        let start = DispatchTime.now()
//
//        closure()
//
//        // End the stopwatch
//        let end = DispatchTime.now()
//
//        // Get the difference in nanoseconds
//        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
//
//        // Get the time interval in seconds
//        let seconds: TimeInterval = Double(nanoTime) / 1_000_000_000
//
//        self.debug("Time elapsed: \(seconds) seconds!")
//
//        return seconds
//    }
    
    // MARK: Methods - Handler Registration
    
    public func registerHandler(_ handler: LogHandler) {
        self.handlers.append(handler)
    }
    
    // MARK: Methods - Utilities
    
    private func message(for item: Any,
                         level: LogLevel,
                         options: LogOptions,
                         file: StaticString = #file,
                         line: UInt = #line) -> String {
        if options.contains(.prettyPrinted),
            let jsonObject = item as? Encodable,
            let jsonMessage = try? jsonObject.toPrettyPrintedJSON() {
            return jsonMessage
        } else {
            return String(describing: item)
        }
    }
    
    private func messagePrefix(for item: Any,
                               level: LogLevel,
                               options: LogOptions,
                               file: StaticString = #file,
                               line: UInt = #line) -> String? {
        // Try to strip the path and only get the filename
        let filename = "\(file)".split(separator: "/").last ?? ""
        
        // If the filename is empty, there's no use returning just a line number
        guard !filename.isEmpty else {
            return nil
        }
        
        // Return the filename and line number enscapsulated by brackets for readability
        return "[\(filename):\(line)]"
    }
}

// TODO: How can we make this conform Codable?
public struct LogEvent {
    public let item: Any
    public let message: String
    public let level: Lincoln.LogLevel
    public let options: Lincoln.LogOptions
//    public let error: Error?
    
    public let file: String
    public let line: UInt
    public let column: UInt
    public let function: String
}

// MARK: - Convenience Methods

/// These convenience methods represent each of the values within `LogLevel`.
public extension Lincoln {
    func critical(_ item: Any,
                  options: LogOptions = [],
                  file: StaticString = #file,
                  line: UInt = #line,
                  column: UInt = #column,
                  function: StaticString = #function) {
        self.log(item, level: .critical, options: options, file: file, line: line, column: column, function: function)
    }
    
    func critical(_ error: Error,
                  message: String? = nil,
                  options: LogOptions = [],
                  file: StaticString = #file,
                  line: UInt = #line,
                  column: UInt = #column,
                  function: StaticString = #function) {
        self.report(error, message: message, level: .critical, options: options, file: file, line: line, column: column, function: function)
    }
    
    func error(_ item: Any,
               options: LogOptions = [],
               file: StaticString = #file,
               line: UInt = #line,
               column: UInt = #column,
               function: StaticString = #function) {
        self.log(item, level: .error, options: options, file: file, line: line, column: column, function: function)
    }
    
    func error(_ error: Error,
               message: String? = nil,
               options: LogOptions = [],
               file: StaticString = #file,
               line: UInt = #line,
               column: UInt = #column,
               function: StaticString = #function) {
        self.report(error, message: message, level: .error, options: options, file: file, line: line, column: column, function: function)
    }
    
    func warning(_ item: Any,
                 options: LogOptions = [],
                 file: StaticString = #file,
                 line: UInt = #line,
                 column: UInt = #column,
                 function: StaticString = #function) {
        self.log(item, level: .warning, options: options, file: file, line: line, column: column, function: function)
    }
    
    func notice(_ item: Any,
                options: LogOptions = [],
                file: StaticString = #file,
                line: UInt = #line,
                column: UInt = #column,
                function: StaticString = #function) {
        self.log(item, level: .notice, options: options, file: file, line: line, column: column, function: function)
    }
    
    func info(_ item: Any,
              options: LogOptions = [],
              file: StaticString = #file,
              line: UInt = #line,
              column: UInt = #column,
              function: StaticString = #function) {
        self.log(item, level: .info, options: options, file: file, line: line, column: column, function: function)
    }
    
    func debug(_ item: Any,
               options: LogOptions = [],
               file: StaticString = #file,
               line: UInt = #line,
               column: UInt = #column,
               function: StaticString = #function) {
        self.log(item, level: .debug, options: options, file: file, line: line, column: column, function: function)
    }
    
    func trace(_ item: Any,
               options: LogOptions = [],
               file: StaticString = #file,
               line: UInt = #line,
               column: UInt = #column,
               function: StaticString = #function) {
        self.log(item, level: .trace, options: options, file: file, line: line, column: column, function: function)
    }
}
