//
//  CardData.swift
//  Shopz
//
//  Created by Rajkumar S on 24/01/22.
//

import Foundation

struct CardData {
    var id: Int
    var name: String
    var number: String
    var validityDate: Date
    
    func toCardFormat() -> String {
        guard number.count > 4 else { return "0000-0000-0000-0000" }
        let startIndex = number.index(number.endIndex, offsetBy: -4)
        return String(repeating: "XXXX-", count: 3) + number[startIndex..<number.endIndex].uppercased()
    }
    
}

struct GiftCardData {
    var id: Int
    var amount: Double
    var validityDate: Date
}
