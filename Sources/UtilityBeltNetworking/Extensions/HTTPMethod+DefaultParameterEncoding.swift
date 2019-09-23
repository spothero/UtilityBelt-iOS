// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public extension HTTPMethod {
    var defaultParameterEncoding: ParameterEncoding {
        switch self {
        case .delete, .get, .head:
            return .queryString
        case .connect, .options, .patch, .post, .put:
            return .httpBody(.json)
        }
    }
}
