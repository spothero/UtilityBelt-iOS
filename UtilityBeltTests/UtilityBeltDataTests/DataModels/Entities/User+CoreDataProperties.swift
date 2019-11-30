//
//  User+CoreDataProperties.swift
//  UtilityBeltDataTests
//
//  Created by Brian Drelling on 11/30/19.
//  Copyright © 2019 SpotHero, Inc. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?

}
