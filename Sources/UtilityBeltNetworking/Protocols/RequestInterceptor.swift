// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public protocol RequestInterceptor: RequestAdapter, RequestRetrier {
    func requestWillStart(_ request: Request)
    func requestDidEnd(_ request: Request)
}

extension RequestInterceptor {
    public func requestWillStart(_ request: Request) {}
    public func requestDidEnd(_ request: Request) {}
}
