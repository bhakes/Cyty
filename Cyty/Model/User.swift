//
//  User.swift
//  Cyty
//
//  Created by Benjamin Hakes on 2/5/19.
//  Copyright © 2019 Benjamin Hakes. All rights reserved.
//

import Foundation
import CoreData

class User {
    var firstName: String
    var lastName: String
    var email: String
    var accountBalance: Double = 0.0
    var password: String = "123"
    var userID: UUID
    
    init(firstName : String, lastName: String, email: String, userID: UUID){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userID = userID
    }
    
}

