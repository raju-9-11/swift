//
//  Auth.swift
//  Shopz
//
//  Created by Rajkumar S on 14/12/21.
//

import Foundation
import CryptoKit

class Auth: NSObject {
    var userName: String
    var cart: [String]
    var authToken: String
    
    override init() {
        self.userName = "pacman"
        self.cart = []
        self.authToken = "Stringaasdasdawq121ewew1e"
    }
    
    static func hashPassword(password: String, salt: String) -> String {
        
        let data = Data((password+salt).utf8)

        let hashed = SHA256.hash(data: data)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    static func verifyPassword(password: String , hashPassword: String, salt: String) -> Bool {
        return self.hashPassword(password: password, salt: salt) == hashPassword
    }
    
    static func saltGen() -> String {
        return String.randomString(length: 10)
    }
    
}

extension String {
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}


