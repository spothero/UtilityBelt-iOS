//
//  File.swift
//  
//
//  Created by Brian Drelling on 10/8/19.
//

import Foundation

public extension URLSession {
    static var sham: URLSession {
        return URLSession(configuration: .sham)
    }
}
