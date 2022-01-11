//
//  JsonModel.swift
//  Shopz
//
//  Created by Rajkumar S on 10/01/22.
//

import Foundation

class JsonModel: Codable {
    var sellers: [Seller]
    var products: [Product]
    var categories: [Category]
}
