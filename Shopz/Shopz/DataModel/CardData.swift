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
    
    func getDateInFormat() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/YYY"
        return dateformatter.string(from: self.validityDate)
    }
}
