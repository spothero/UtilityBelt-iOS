// Copyright © 2019 SpotHero, Inc. All rights reserved.

public enum ParameterEncoding {
    case httpBody(HTTPBodyEncoding)
    case queryString
    
    static func defaultEncoding(for method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .delete, .get, .head:
            return .queryString
        case .connect, .options, .patch, .post, .put:
            return .httpBody(.json)
        }
    }
}
