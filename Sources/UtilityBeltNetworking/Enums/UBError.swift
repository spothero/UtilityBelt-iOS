//
//  File.swift
//  
//
//  Created by Brian Drelling on 10/3/19.
//

import Foundation

public enum UBError: Swift.Error {
    case invalidURLString(String)
}

extension UBError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURLString(let urlString):
            return "Invalid URL string: '\(urlString)'."
        }
    }
}
