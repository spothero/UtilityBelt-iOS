//
//  File.swift
//  
//
//  Created by Brian Drelling on 10/8/19.
//

import Foundation

public extension URLSessionConfiguration {
    static var sham: URLSessionConfiguration {
        let urlConfig: URLSessionConfiguration = .default
        urlConfig.protocolClasses = [MockURLProtocol.self]
        
        return urlConfig
    }
}
