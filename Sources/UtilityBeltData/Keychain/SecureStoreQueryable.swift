// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

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
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = self.service
        // Access group if target environment is not simulator
        #if !targetEnvironment(simulator)
            if let accessGroup = accessGroup {
                query[String(kSecAttrAccessGroup)] = accessGroup
            }
        #endif
        return query
    }
}

public struct InternetPasswordQueryable {
    let server: String
    let port: Int
    let path: String
    let securityDomain: String
    let internetProtocol: InternetProtocol
    let internetAuthenticationType: InternetAuthenticationType
}

extension InternetPasswordQueryable: SecureStoreQueryable {
    public var query: [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassInternetPassword
        query[String(kSecAttrPort)] = self.port
        query[String(kSecAttrServer)] = self.server
        query[String(kSecAttrSecurityDomain)] = self.securityDomain
        query[String(kSecAttrPath)] = self.path
        query[String(kSecAttrProtocol)] = self.internetProtocol.rawValue
        query[String(kSecAttrAuthenticationType)] = self.internetAuthenticationType.rawValue
        return query
    }
}
