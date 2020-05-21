// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

// TODO: Lincoln has to be able to have metadata at the class and event level.
// TODO: Add timestamps to logs.
// TODO: Measure the speed to ensure optimal performance.
// TODO: Experiment with Combine conformance?
// TODO: Include a domain or label for Lincoln to log events under?
// TODO: Instead of a static object or singleton, should I instantiate Loggers?

public class Lincoln {
    // MARK: Shared Instance
    
    public static let shared = Lincoln()
    
    // MARK: Enums
    
    /// Indicates the severity or condition of a log event.
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
    
    // MARK: Properties
    
    // TODO: Adjust the log level depending on the DEBUG flag
    
    /// Indicates the minimum severity or condition threshold that should process log events.
    /// Log levels range from `.trace` (lowest severity) to `.critical` (highest severity).
    /// Setting this property will log all events of a matching or higher severity.
    /// Defaults to `.trace` in Debug configurations and `.info` in Release configurations.
    public var logLevel: LogLevel = {
        #if DEBUG
            return .trace
        #else
            return .info
        #endif
    }()
    
    /// The handlers to use for processing log events. A handler must be registered for logs to be processed.
    /// There is no guaranteed order that the handlers will be called in.
    ///
    /// By default, a `PrintLogHandler` is registered when running in Debug configuration,
    /// which simply prints to the console using the `print()` function.
    private var handlers: [LogHandler] = [PrintLogHandler()]
    
    // MARK: Methods - Logging
    
    // TODO: Update log to process multiple items.
    
    /// Logs information for the given item.
    ///
    /// - Parameters:
    ///   - item: The item to log information about.
    ///   - level: The severity of the log event. Defaults to `.info`, indicating an informational log.
    ///   - file: The file that called this method.
    ///   - line: The line that this method was called on.
    ///   - column: The column that called this method was called on.
    ///   - function: The function that this method was called within.
    public func log(_ item: Any,
                    level: LogLevel = .info,
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
        
        // Create a log event object for ease of passing around
        let event = LogEvent(item: item,
//                             message: message,
                             level: level,
                             filePath: file,
                             line: line,
                             column: column,
                             function: function)
        
        // Finally, send the log events to the registered handlers
        self.handlers.forEach { $0.log(event) }
    }
    
    // TODO: Consider wrapping the error here if a message is supplied, then passing it into the log function.
    
    func report(_ error: Error,
                message: String?,
                level: LogLevel,
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
        
        self.log(logMessage, level: level, file: file, line: line)
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
    
    // TODO: It isn't clear that this method unregisters existing handlers.
    public func register(_ handler: LogHandler) {
        self.handlers = [handler]
    }
    
    // TODO: It isn't clear that this method unregisters existing handlers.
    public func register(_ handlers: [LogHandler]) {
        self.handlers = handlers
    }
}
