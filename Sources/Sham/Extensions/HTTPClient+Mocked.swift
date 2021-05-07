// Copyright © 2021 SpotHero, Inc. All rights reserved.

#if canImport(UtilityBeltNetworking)
    
    import UtilityBeltNetworking
    
    public extension HTTPClient {
        /// An HTTPClient set up to work with the MockService on top of the default settings.
        static let mocked = HTTPClient(session: .mocked)
    }
    
#endif
