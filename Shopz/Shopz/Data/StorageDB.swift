//
//  Products.swift
//  Shopz
//
//  Created by Rajkumar S on 31/12/21.
//

import Foundation

class StorageDB {
    
    static func getProducts() -> [Product] {
        if let path = Bundle.main.path(forResource: "StaticData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONDecoder().decode(JsonModel.self, from: data)
                return jsonResult.products
            } catch {
                print("JSON ERROR \(error)")
            }
        }
        return []
    }
    
    static func getCategories() -> [Category] {
        if let path = Bundle.main.path(forResource: "StaticData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONDecoder().decode(JsonModel.self, from: data)
                return jsonResult.categories
            } catch {
                print("JSON ERROR \(error)")
            }
        }
        return []
    }
    
    static func getProducts(with query: String) -> [Product] {
        if let path = Bundle.main.path(forResource: "StaticData", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONDecoder().decode(JsonModel.self, from: data)
                return jsonResult.products.filter({ product in return product.product_name.lowercased().contains(query.lowercased()) })
            } catch {
                print("JSON ERROR")
            }
        }
        return []
    }
}
