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
