// Copyright © 2019 SpotHero, Inc. All rights reserved.

#if canImport(UtilityBeltNetworking)

    import UtilityBeltNetworking

    public extension HTTPClient {
        /// An HTTPClient set up to work with Sham's MockService on top of the default settings.
        static let sham = HTTPClient(session: .sham)
    }

#endif
