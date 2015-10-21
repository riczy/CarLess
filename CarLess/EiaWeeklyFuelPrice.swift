import Foundation

struct EiaWeeklyFuelPrice: CustomStringConvertible, Comparable {
    
    var startDate: NSDate
    var endDate: NSDate
    var price: NSDecimalNumber
    var seriesId: String?
    
    var description: String {
        get {
            return "\(price), \(startDate) - \(endDate), \(seriesId)"
        }
    }
    
    func isDateWithinRange(date: NSDate) -> Bool {
        
        return date.isOnOrAfter(startDate) && date.isOnOrBefore(endDate)
    }
    
}

func ==(lhs: EiaWeeklyFuelPrice, rhs: EiaWeeklyFuelPrice) -> Bool {
    
    return lhs.startDate == rhs.startDate
}

func <(lhs: EiaWeeklyFuelPrice, rhs: EiaWeeklyFuelPrice) -> Bool {
    
    return lhs.startDate.isBefore(rhs.startDate)
}
