//
//  Users.swift
//  Tamo
//
//  Created by Reashed Tulon on 26/2/21.
//

import Foundation

struct Users: Codable {
    
    let userId: String?
    let authToken: String?
    let email: String?
    let password: String?
    let avatar: String?
    let firstName: String?
    let lastName: String?
    
    init(userId: String, authToken: String, email: String, password: String, avatar: String, firstName: String, lastName: String) {
        self.userId = userId
        self.authToken = authToken
        self.email = email
        self.password = password
        self.avatar = avatar
        self.firstName = firstName
        self.lastName = lastName
    }
}
