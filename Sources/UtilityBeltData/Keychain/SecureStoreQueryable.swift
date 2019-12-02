// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

// swiftlint:disable missing_docs

public protocol SecureStoreQueryable {
    var query: [String: Any] { get }
}

public struct GenericPasswordQueryable {
    let service: String
    let accessGroup: String?

    init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }
}

extension GenericPasswordQueryable: SecureStoreQueryable {
    public var query: [String: Any] {
        var query: [String: Any] = [:]

        query[String(kSecClass)] = KeychainClass.genericPassword.rawValue

        query[KeychainAttribute.service.rawValue] = self.service
        // Access group if target environment is not simulator
        #if !targetEnvironment(simulator)
            if let accessGroup = accessGroup {
                query[KeychainAttribute.General.accessGroup.rawValue] = accessGroup
            }
        #endif
        return query
    }
}

public struct InternetPasswordQueryable {
    let authenticationType: KeychainAuthenticationType
    let path: String
    let port: Int
    let `protocol`: KeychainInternetProtocol
    let securityDomain: String
    let server: String
}

extension InternetPasswordQueryable: SecureStoreQueryable {
    public var query: [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = KeychainClass.internetPassword.rawValue
        
        query[KeychainAttribute.authenticationType.rawValue] = self.authenticationType.rawValue
        query[KeychainAttribute.path.rawValue] = self.path
        query[KeychainAttribute.port.rawValue] = self.port
        query[KeychainAttribute.protocol.rawValue] = self.protocol.rawValue
        query[KeychainAttribute.securityDomain.rawValue] = self.securityDomain
        query[KeychainAttribute.server.rawValue] = self.server

        return query
    }
}
