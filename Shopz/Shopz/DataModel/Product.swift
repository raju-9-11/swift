//
//  Product.swift
//  Shopz
//
//  Created by Rajkumar S on 10/01/22.
//

import Foundation

struct Product: Codable {
    
    var product_id: Int
    var product_name: String
    var seller_id: Int
    var image_media: [String]
    var shipping_cost: Decimal
    var description: String
    var price: Decimal
    var rating: Decimal
    var category: String
}
