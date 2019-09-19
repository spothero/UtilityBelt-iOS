
@testable import UtilityBeltNetworking
import XCTest

final class HTTPClientTests: XCTestCase {
    func testGeneric() {
        
        HTTPClient.shared.test()
    }
}
