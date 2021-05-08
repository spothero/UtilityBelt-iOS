// Copyright © 2021 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation

@objc(User)
class User: NSManagedObject {
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged var email: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
}
