// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

extension NSPredicate {
    convenience init(key: String, equalTo value: Any) {
        self.init(key, "==", value)
    }
    
    convenience init(key: String, contains value: String) {
        self.init(key, "CONTAINS[cd]", value)
    }
    
    private convenience init(_ key: String, _ operatorFunc: String, _ value: Any) {
        self.init(format: "%K \(operatorFunc) %@", argumentArray: [key, value])
    }
}
