// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public extension URLSession {
    static var sham: URLSession {
        return URLSession(configuration: .sham)
    }
}
