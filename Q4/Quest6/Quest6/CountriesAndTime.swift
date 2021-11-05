//
//  CountriesAndTime.swift
//  Quest6
//
//  Created by Rajkumar S on 03/11/21.
//

import Foundation


class CountriesAndTime {
    
    static let countries = ["India": "Asia/Kolkata", "Nepal": "Asia/Kathmandu ", "Beijing":"Asia/Beijing", "Turkey": "Europe/Istanbul", "Rome": "Europe/Rome", "Sydney": "Australia/Sydney", "Toronto": "America/Toronto", "Montreal": "America/Montreal", "Alaska": "America/Juneau", "Shanghai": "Asia/Shangai", "Ho Chi Minh": "Asia/Ho_Chi_Minh", "Dublin": "Europe/Dublin", "Berlin": "Europe/Berlin", "California": "America/Los_Angeles", "New York": "America/New_York"]
    static var time: [DataModel] {
        get {
            var timeForCountries: [DataModel] = []
            for (country, timeZone) in countries {
                timeForCountries.append(DataModel(country: country, timeZone: timeZone, time: localTime(in: timeZone)))
            }
            return timeForCountries
        }
    }
}


func localTime(in timeZone: String) -> String {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime]
    f.timeZone = TimeZone(identifier: timeZone)
    return f.string(from: Date())
}
 

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
