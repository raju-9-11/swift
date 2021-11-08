//
//  CountriesAndTime.swift
//  Quest6
//
//  Created by Rajkumar S on 03/11/21.
//

import Foundation


class CountriesAndTime {
    
    static var countries = ["India": "IST", "Nepal": "NPT", "Beijing":"CST", "Turkey": "TRT", "Rome": "CET", "Sydney": "AEST", "Toronto": "EST", "Montreal": "EST", "Alaska": "AKST", "Shanghai": "CST", "Ho Chi Minh": "ICT", "Dublin": "GMT", "Berlin": "CET", "California": "PST", "New York": "EST"] 
        
    static var time: [DataModel] {
        get {
            var timeForCountries: [DataModel] = []
            for (country, timeZone) in countries {
                timeForCountries.append(DataModel(country: country, timeZone: timeZone, day: localDay(in: timeZone), hour24: false))
            }
            return timeForCountries
        }
    }
}


func localTime(in timeZone: String, hour24: Bool) -> String {
    let timeFormatterPrint = DateFormatter()
    timeFormatterPrint.dateFormat = hour24 ? "HH:mm:ss" : "hh:mm:ss a"
    timeFormatterPrint.timeZone = TimeZone(abbreviation: timeZone)
    let time = timeFormatterPrint.string(from: Date())
    return time

}

func localDay(in timeZone: String) -> [String: String] {
    let timeFormatter = DateFormatter()
    timeFormatter.timeZone = TimeZone(abbreviation: timeZone)
    timeFormatter.dateFormat = "dd-MMM-yyyy"
    var day: [String: String]  = ["date": timeFormatter.string(from: Date())]
    timeFormatter.dateFormat = "EEEE"
    day["day"] = timeFormatter.string(from: Date())
    return day
}
