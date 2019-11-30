// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
@testable import UtilityBeltData
import XCTest

protocol UserDataLoading: XCTestCase {}

extension UserDataLoading {
    func loadData(file: StaticString = #file, line: UInt = #line) throws {
        let alice = try User.newInstance()
        alice?.firstName = "Alice"
        alice?.lastName = "Anderson"
        alice?.email = "alice@spothero.com"

        let bob = try User.newInstance()
        bob?.firstName = "Bob"
        bob?.lastName = "Barker"
        bob?.email = "bob@spothero.com"

        let carol = try User.newInstance()
        carol?.firstName = "Carol"
        carol?.lastName = "Chompers"
        carol?.email = "carol@spothero.com"

        let dave = try User.newInstance()
        dave?.firstName = "Dave"
        dave?.lastName = "Davison"
        dave?.email = "dave@spothero.com"

        try CoreDataManager.default.saveDefaultContext()
    }
}
