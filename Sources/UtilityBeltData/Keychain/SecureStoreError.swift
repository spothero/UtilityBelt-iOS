//
//  File.swift
//  
//
//  Created by Brian Drelling on 12/5/19.
//

import Foundation

public enum SecureStoreError: Error {
    case string2DataConversionError
    case data2StringConversionError
    case unhandledError(message: String)
}

extension SecureStoreError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .string2DataConversionError:
            return NSLocalizedString("String to Data conversion error", comment: "")
        case .data2StringConversionError:
            return NSLocalizedString("Data to String conversion error", comment: "")
        case let .unhandledError(message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
