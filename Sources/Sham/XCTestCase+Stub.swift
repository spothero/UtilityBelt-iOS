//
//  File.swift
//  
//
//  Created by Brian Drelling on 9/19/19.
//

import XCTest

public extension XCTestCase {
    func stub(_ stubRequest: StubRequest, with response: StubResponse) {
        MockService.shared.stub(stubRequest, with: response)
    }
    
    func stub(_ urlRequest: URLRequest, with response: StubResponse) {
        MockService.shared.stub(urlRequest, with: response)
    }
    
    func stub(_ url: URL, with response: StubResponse) {
        MockService.shared.stub(url, with: response)
    }
}
