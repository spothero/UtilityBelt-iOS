// Copyright © 2023 SpotHero, Inc. All rights reserved.

import Foundation
@testable import UtilityBeltNetworking

protocol URLRequesting {}

extension URLRequesting {
    func urlRequest(url: URLConvertible,
                    method: HTTPMethod = .get,
                    parameters: ParameterDictionaryConvertible? = nil,
                    headers: HTTPHeaderDictionaryConvertible? = nil,
                    encoding: ParameterEncoding? = nil,
                    timeout: TimeInterval? = 0.1) throws -> URLRequest {
        var request = try URLRequest(
            url: url,
            method: method,
            parameters: parameters,
            headers: headers,
            encoding: encoding
        )

        if let timeout = timeout {
            request.timeoutInterval = timeout
        }

        return request
    }
}
