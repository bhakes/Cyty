//
//  User+Convenience.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/5/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreData

extension User {
    convenience init(firstName: String,
                     lastName: String,
                     email: String,
                     accountBalance: Double = 0.0,
                     password: String = "123",
                     userID: UUID = UUID(),
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context:context)
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.accountBalance = accountBalance
        self.password = password
        self.userID = userID
        
    }
}

