//
//  ShoppingList.swift
//  Shopz
//
//  Created by Rajkumar S on 25/01/22.
//

import Foundation


class ShoppingList {
    var name: String
    var id: Int
    var userId: Int
    
    init(id: Int, name: String, userID: Int) {
        self.name = name
        self.id = id
        self.userId = userID
    }
}
