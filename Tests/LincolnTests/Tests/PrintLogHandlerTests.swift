// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
@testable import Lincoln
import XCTest

final class PrintHandlerTests: XCTestCase {
    func testLogging() throws {
        let logger = TestPrintLogger()
        Lincoln.shared.register(logger)
        
        Lincoln.shared.log("Lorem ipsum dolor sit amet.")
    }
    
    private func log(_ item: Any, completion: @escaping (LogEvent) -> Void) {
        // Create an expectation
        let expectation = self.expectation(description: "Log item '\(String(describing: item))'.")
        
        // Create a test logger to handle the log events
        let logger = TestLogger(expectation: expectation, completion: completion)
        
        // Register it to the shared Lincoln instance
        Lincoln.shared.register(logger)
        
        // Log an item through the same Lincoln instance
        Lincoln.shared.log(item)
        
        // Wait for expectations to complete
        self.wait(for: [logger.expectation], timeout: 0.1)
    }
}

struct TestPrintLogger: LogHandler, LogPrinting {
    let expectation: XCTestExpectation
    let completion: (LogEvent) -> Void
    
    func log(_ event: LogEvent) {
        self.completion(event)
        
        self.expectation.fulfill()
    }
}
