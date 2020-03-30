// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public enum UBCoreDataError: Error {
    case defaultPersistentContainerNotSet
}

extension UBCoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .defaultPersistentContainerNotSet:
            return "CoreDataManager.defaultContainer must be set before calling CoreDataManager.default for any operations."
        }
    }
}
