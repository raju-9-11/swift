//
//  CountriesAndTime.swift
//  Quest6
//
//  Created by Rajkumar S on 03/11/21.
//

import Foundation


class CountriesAndTime {
    
    static let dateFormats = [ "dd-MMM-yyyy", "dd-MM-yyyy", "yyyy-MM-dd"]
    static let timeFormats = ["hh:mm:ss", "hh:mm"]
    
    static var countries = ["India": "IST", "Nepal": "NPT", "Beijing":"CST", "Turkey": "TRT", "Rome": "CET", "Sydney": "AEST", "Toronto": "EST", "Montreal": "EST", "Alaska": "AKST", "Shanghai": "CST", "Ho Chi Minh": "ICT", "Dublin": "GMT", "Berlin": "CET", "California": "PST", "New York": "EST"] 
        
    static var time: [DataModel] {
        get {
            var timeForCountries: [DataModel] = []
            for (country, timeZone) in countries {
                timeForCountries.append(DataModel(country: country, timeZone: timeZone))
            }
            return timeForCountries
        }
    }
}


func localTime(in timeZone: String, hour24: Bool = true, timeFormat: String = "hh:mm:ss", date: Date) -> String {
    let timeFormatterPrint = DateFormatter()
    timeFormatterPrint.dateFormat = hour24 ? timeFormat.replacingOccurrences(of: "h", with: "H") : "\(timeFormat) a"
    timeFormatterPrint.timeZone = TimeZone(abbreviation: timeZone)
    let time = timeFormatterPrint.string(from: date)
    return time

}

func localDay(in timeZone: String, dateFormat: String = "dd-MMM-yyyy", date: Date) -> [String: String] {
    let timeFormatter = DateFormatter()
    timeFormatter.timeZone = TimeZone(abbreviation: timeZone)
    timeFormatter.dateFormat = dateFormat
    var day: [String: String]  = ["date": timeFormatter.string(from: date)]
    timeFormatter.dateFormat = "EEEE"
    day["day"] = timeFormatter.string(from: date)
    return day
}
