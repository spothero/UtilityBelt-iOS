// Copyright © 2019 SpotHero, Inc. All rights reserved.

#if canImport(UtilityBeltNetworking)

    import UtilityBeltNetworking

    public extension HTTPClient {
        /// Convenience initializer for an HTTPClient set up to work with a Sham MockService
        static let sham = HTTPClient(session: .sham)
    }

#endif
