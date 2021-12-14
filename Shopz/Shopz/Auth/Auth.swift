//
//  Auth.swift
//  Shopz
//
//  Created by Rajkumar S on 14/12/21.
//

import Foundation

class Auth: NSObject {
    var authState: Bool
    var userName: String
    var cart: [String]
    var authToken: String
    
    override init() {
        self.authState = true
        self.userName = "pacman"
        self.cart = []
        self.authToken = "Stringaasdasdawq121ewew1e"
    }
    
}
