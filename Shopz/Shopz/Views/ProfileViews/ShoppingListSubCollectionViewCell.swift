//
//  ShoppingListSubCollectionViewCell.swift
//  Shopz
//
//  Created by Rajkumar S on 15/12/21.
//

import UIKit

class ShoppingListSubCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "ShoppingListCell"
    
    var listDetails: ShoppingListDetails? {
        willSet {
            if newValue != nil {
                
                self.setupLayout()
            }
        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            
        ])
    }
}

class ShoppingListDetails {
    
    var name: String
    
    init(name: String ) {
        self.name = name
    }
    
}
