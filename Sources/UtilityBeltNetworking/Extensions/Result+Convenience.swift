// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

extension Result {
    /// Returns the associated value if the result is a success, or nil if it is a failure.
    var success: Success? {
        guard case let .success(value) = self else {
            return nil
        }
        
        return value
    }
    
    /// Returns the associated error value if the result is a failure, or nil if it is a success.
    var failure: Failure? {
        guard case let .failure(error) = self else {
            return nil
        }
        
        return error
    }
}
