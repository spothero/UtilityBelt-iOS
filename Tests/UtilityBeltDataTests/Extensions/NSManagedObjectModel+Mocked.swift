// Copyright © 2021 SpotHero, Inc. All rights reserved.

import CoreData
import Foundation

extension NSManagedObjectModel {
    static var mocked: NSManagedObjectModel {
        let model = NSManagedObjectModel()
        
        // Create the entity
        let entity = NSEntityDescription()
        entity.name = "User"
        // Assume that there is a correct
        // `CachedFile` managed object class.
        entity.managedObjectClassName = String(describing: User.self)
        
        // Create the attributes
        var properties = [NSAttributeDescription]()
        
        let emailAttribute = NSAttributeDescription()
        emailAttribute.name = "email"
        emailAttribute.attributeType = .stringAttributeType
        emailAttribute.isOptional = true
        emailAttribute.isIndexed = false
        properties.append(emailAttribute)
        
        let firstNameAttribute = NSAttributeDescription()
        firstNameAttribute.name = "firstName"
        firstNameAttribute.attributeType = .stringAttributeType
        firstNameAttribute.isOptional = true
        firstNameAttribute.isIndexed = false
        properties.append(firstNameAttribute)
        
        let lastNameAttribute = NSAttributeDescription()
        lastNameAttribute.name = "lastName"
        lastNameAttribute.attributeType = .stringAttributeType
        lastNameAttribute.isOptional = true
        lastNameAttribute.isIndexed = false
        properties.append(lastNameAttribute)
        
        // Add attributes to entity
        entity.properties = properties
        
        // Add entity to model
        model.entities = [entity]
        
        // Done :]
        return model
    }
}
