// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public enum UBDataError: Error {
    case defaultPersistentContainerNotSet
}

extension UBDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .defaultPersistentContainerNotSet:
            return "CoreDataManager.defaultContainer must be set before calling CoreDataManager.default for any operations."
        }
    }
}

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
