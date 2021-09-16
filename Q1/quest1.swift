func leapYear(_ year: Int) -> Bool {
    if year%4 == 0 {
        if year%100 == 0 {
            if year%400 == 0 {
                return true
            }
            return false
        }
        return true
    }
    return false
}

func countMinutes(_ month: Int, _ year: Int) -> Int {
    let minInDay: Int = 1440
    if month == 2 {
        if leapYear(year) {
            return minInDay * 29
        }
        return minInDay * 28
    }
    let month = month > 7 ? month%7 : month
    return minInDay * (month % 2 == 0 ? 30 : 31)
    
}
var myMinutes:[Int:[Int]] = [:]
for year in 2008...2021 {
    var minutes: [Int] = []
    for month in 1...12 {
        minutes.append(countMinutes(month,year))
    }
    myMinutes[year] = minutes
}

let sortedMinutes = myMinutes.sorted( by: { $0.0 < $1.0 })

for ( year, _ ) in sortedMinutes {
    print (" \(year) : Minutes in Year \(sortedMinutes[year]) ")
}