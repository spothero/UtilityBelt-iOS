// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
@testable import Lincoln
import XCTest

@available(iOS 13.0, *)
/// Tests that help to ensure our print logging performance does not bloat an application it is embedded within.
///
/// Unfortunately, it is not possible to set baseline metrics for performance tests in Swift Packages.
/// In standard Xcode projects, we can generate baseline metrics that are then included in the project.
/// Since SPM has no xcodeproj or manifest files, we cannot save baseline metrics to validate against.
/// As such, these tests are purely for troubleshooting locally.
///
/// Additionally, we use `XCTMeasureOptions`, which is only available in iOS 13.
final class PrintLogHandlerPerformanceTests: XCTestCase {
    // MARK: Constants
    
    /// The total invocations of a command within a given measurement block.
    /// Each measurement block will run this many invocations multipled by the iterations.
    private static let totalInvocations = 1000
    
    /// The measurement options for the measurement blocks.
    /// We use the default measuremenet options but set the iteration count,
    /// which literally runs the block that many times.
    /// A higher number improves the average and standard deviation.
    private static let measurementOptions: XCTMeasureOptions = {
        let options: XCTMeasureOptions = .default
        options.iterationCount = 10
        
        return options
    }()
    
    // MARK: Enums
    
    enum TestError: Error, LocalizedError {
        case generic
        
        var errorDescription: String? {
            switch self {
            case .generic:
                return "This is a generic error message."
            }
        }
    }
    
    // MARK: Tests
    
    /// This function provides our baseline metrics for a raw print command.
    func testPrintingPerformance() throws {
        // Baseline: ~0.0085s
        self.measure(options: Self.measurementOptions) {
            for _ in 0 ..< Self.totalInvocations {
                print("Lorem ipsum dolor sit amet.")
            }
        }
    }
    
    /// This function provides our baseline metrics for logging messages via Lincoln with NO additional formatting.
    func testNonFormattedMessageLoggingPerformance() throws {
        let lincoln = self.lincolnWithPrintLogHandler()
        
        // Baseline: ~0.0085s
        // Result:   Approximately identical to raw printing.
        self.measure {
            for _ in 0 ..< Self.totalInvocations {
                lincoln.log("Lorem ipsum dolor sit amet.")
            }
        }
    }
    
    /// This function provides our baseline metrics for logging messages via Lincoln with ALL additional formatting options enabled.
    func testFormattedMessageLoggingPerformance() throws {
        let lincoln = self.lincolnWithPrintLogHandler(options: Set(PrintLogHandler.LogOption.allCases))
        
        // Baseline: ~0.045s
        // Result:   Approximately 5x as long as non-formatted message logging.
        self.measure {
            for _ in 0 ..< Self.totalInvocations {
                lincoln.log("Lorem ipsum dolor sit amet.")
            }
        }
    }
    
    /// This function provides our baseline metrics for logging errors via Lincoln with NO additional formatting.
    func testNonFormattedErrorLoggingPerformance() throws {
        let lincoln = self.lincolnWithPrintLogHandler()
        
        // Baseline: ~0.02s
        // Result:   Approximately 2x as long as non-formatted message logging.
        self.measure {
            for _ in 0 ..< Self.totalInvocations {
                lincoln.error(TestError.generic, message: "Lorem ipsum dolor sit amet.")
            }
        }
    }
    
    /// This function provides our baseline metrics for logging errors via Lincoln with ALL additional formatting options enabled.
    func testFormattedErrorLoggingPerformance() throws {
        let lincoln = self.lincolnWithPrintLogHandler(options: Set(PrintLogHandler.LogOption.allCases))
        
        // Baseline: ~0.065s
        // Result:   Approximately 6x as long as non-formatted message logging.
        self.measure {
            for _ in 0 ..< Self.totalInvocations {
                lincoln.error(TestError.generic, message: "Lorem ipsum dolor sit amet.")
            }
        }
    }
    
    private func lincolnWithPrintLogHandler(options: PrintLogHandler.LogOptions = []) -> Lincoln {
        // Create local Lincoln instance
        let lincoln = Lincoln()
        
        // Create a PrintLogHandler with ALL options enabled
        let logger = PrintLogHandler(options: options)
        
        // Register the logger to the same lincoln instance
        lincoln.register(logger)
        
        return lincoln
    }
}
