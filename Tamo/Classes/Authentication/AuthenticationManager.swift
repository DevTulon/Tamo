//
//  AuthenticationManager.swift
//  Tamo
//
//  Created by Reashed Tulon on 1/3/21.
//

import Foundation

class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() { }
    
    func checkIfUserEmailMatched(email: String, userArray: [Users], completion: @escaping(_ isMatched: Bool) -> ()) {
        var isMatched = false
        for user in userArray {
            if let eml = user.email {
                if eml == email {
                    isMatched = true
                }
            }
        }
        completion(isMatched)
    }
    
    func checkIfUserPasswordMatched(password: String, userArray: [Users], completion: @escaping(_ isMatched: Bool,_ user: Users?) -> ()) {
        var isMatched = false
        var usr: Users?
        
        for user in userArray {
            if let psswrd = user.password {
                if psswrd == password {
                    isMatched = true
                    usr = user
                }
            }
        }
        completion(isMatched, usr)
    }
}
