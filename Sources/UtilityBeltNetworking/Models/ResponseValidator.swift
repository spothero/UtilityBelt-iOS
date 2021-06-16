// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

/// A function that validates an HTTPURLResponse.  Throwing an error indicates a failed validation.
public typealias ValidationBlock = (HTTPURLResponse) throws -> Void

/// An object that can validate URL responses.
public struct ResponseValidator {
    // MARK: Properties

    private let validationCheck: ValidationBlock

    // MARK: Methods

    func validate(response: HTTPURLResponse) throws {
        try self.validationCheck(response)
    }
}

// MARK: - Common Validators

public extension ResponseValidator {
    /// Creates a validator that will ensure the response has a specific mime type
    /// - Parameter mimeType: The mime type we want to validate the existance of.
    /// - Returns: The validator that will do this check.
    static func ensureMimeType(_ mimeType: MimeType) -> ResponseValidator {
        return ResponseValidator { response in
            let responseMimeType = response.mimeType
            if responseMimeType != mimeType.rawValue {
                throw UBNetworkError.invalidContentType(responseMimeType ?? "unknown")
            }
        }
    }
    
    /// Creates a validator that will ensure the response status code is not an error code.
    /// - Returns: The validator that will do this check.
    static let validateStatusCode = ResponseValidator { response in
        let status = response.status
        if status.responseType == .clientError || status.responseType == .serverError {
            throw UBNetworkError.invalidStatusCode(status)
        }
    }
}
