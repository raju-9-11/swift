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

struct CountryJson: Codable {
    var countries: [Country]
}

struct Country: Codable {
    var country: String
    var alpha2Code: String
    var alpha3Code: String
    var numberCode: String
    var states: [String]
}
