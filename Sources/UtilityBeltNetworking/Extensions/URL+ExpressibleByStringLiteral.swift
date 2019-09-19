//
//  File.swift
//  
//
//  Created by Brian Drelling on 9/18/19.
//

import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}
