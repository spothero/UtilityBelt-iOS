// Copyright © 2020 SpotHero, Inc. All rights reserved.

/// These convenience methods represent each of the values within `LogLevel`.
public extension Lincoln {
    func critical(_ item: Any,
                  file: StaticString = #file,
                  line: UInt = #line,
                  column: UInt = #column,
                  function: StaticString = #function) {
        self.log(item, level: .critical, file: file, line: line, column: column, function: function)
    }
    
    func critical(_ error: Error,
                  message: String? = nil,
                  file: StaticString = #file,
                  line: UInt = #line,
                  column: UInt = #column,
                  function: StaticString = #function) {
        self.report(error, message: message, level: .critical, file: file, line: line, column: column, function: function)
    }
    
    func error(_ item: Any,
               file: StaticString = #file,
               line: UInt = #line,
               column: UInt = #column,
               function: StaticString = #function) {
        self.log(item, level: .error, file: file, line: line, column: column, function: function)
    }
    
    func error(_ error: Error,
               message: String? = nil,
               file: StaticString = #file,
               line: UInt = #line,
               column: UInt = #column,
               function: StaticString = #function) {
        self.report(error, message: message, level: .error, file: file, line: line, column: column, function: function)
    }
    
    func warning(_ item: Any,
                 file: StaticString = #file,
                 line: UInt = #line,
                 column: UInt = #column,
                 function: StaticString = #function) {
        self.log(item, level: .warning, file: file, line: line, column: column, function: function)
    }
    
    func notice(_ item: Any,
                file: StaticString = #file,
                line: UInt = #line,
                column: UInt = #column,
                function: StaticString = #function) {
        self.log(item, level: .notice, file: file, line: line, column: column, function: function)
    }
    
    func info(_ item: Any,
              file: StaticString = #file,
              line: UInt = #line,
              column: UInt = #column,
              function: StaticString = #function) {
        self.log(item, level: .info, file: file, line: line, column: column, function: function)
    }
    
    func debug(_ item: Any,
               file: StaticString = #file,
               line: UInt = #line,
               column: UInt = #column,
               function: StaticString = #function) {
        self.log(item, level: .debug, file: file, line: line, column: column, function: function)
    }
    
    func trace(_ item: Any,
               file: StaticString = #file,
               line: UInt = #line,
               column: UInt = #column,
               function: StaticString = #function) {
        self.log(item, level: .trace, file: file, line: line, column: column, function: function)
    }
}
