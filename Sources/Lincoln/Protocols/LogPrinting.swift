// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public protocol LogPrinting: LogHandler {
    func prettyPrintedMessage(for event: LogEvent) -> String
    func messagePrefix(for event: LogEvent) -> String?
}

public extension LogPrinting {
    func prettyPrintedMessage(for event: LogEvent) -> String {
        if let jsonObject = event.item as? Encodable,
            let jsonMessage = try? jsonObject.toPrettyPrintedJSON() {
            return jsonMessage
        } else {
            return String(describing: event.item)
        }
    }
    
    func messagePrefix(for event: LogEvent) -> String? {
        // Try to strip the path and only get the filename
        let filename = "\(event.filePath)".split(separator: "/").last ?? ""
        
        // If the filename is empty, there's no use returning just a line number
        guard !filename.isEmpty else {
            return nil
        }
        
        // Return the filename and line number enscapsulated by brackets for readability
        return "[\(filename):\(event.line)]"
    }
}
