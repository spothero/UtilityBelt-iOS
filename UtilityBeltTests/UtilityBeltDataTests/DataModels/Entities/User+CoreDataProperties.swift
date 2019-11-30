// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var lastName: String?
    @NSManaged public var firstName: String?
    @NSManaged public var email: String
}
