// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

/// The result of an HTTP request.
public enum HTTPResultStatus {
    /// The HTTP request was successful, implying there was no error and that the status code was in the 2xx range.
    /// Does not dictate whether or not data was returned.
    case success
    /// The HTTP request was unsuccessful, implying there was either an error or the status code was in the 4xx or 5xx range.
    case failure(Error)

    #warning("TODO: We need to account for 1xx and 3xx properly here, but it will take some discussion.")
}
