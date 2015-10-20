import Foundation

struct EiaWeeklyFuelPrice: CustomStringConvertible, Comparable {
    
    var startDate: NSDate
    var endDate: NSDate
    var price: Double
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

class EiaWeeklyFuelPriceParser: NSObject {
    
    private var data: NSData
    private var seriesId: String?
    var latestFuelPrice: EiaWeeklyFuelPrice?
    
    init(data: NSData) {
        
        self.data = data
    }
    
    /// Answers true if the given fuel price's end date is after the end date of
    /// the latestFuelPrice property. Answers false if the given fuel price's
    /// end date is on or before.
    ///
    private func isAfterLatestFuelPrice(fuelPrice: EiaWeeklyFuelPrice) -> Bool {
    
        if let endDate = latestFuelPrice?.endDate {
            return fuelPrice.endDate.isAfter(endDate)
        }
        return true
    }
    
    func parsePriceForDate(date: NSDate) throws -> EiaWeeklyFuelPrice? {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        
        if let priceDataArray = try getDataArray() {
            
            for price in priceDataArray {
                
                if let priceObjectArray = price as? NSArray {
                    
                    let startDateString = priceObjectArray[0] as? String
                    let amount = priceObjectArray[1] as? Double
                    
                    if startDateString != nil && amount != nil {
                        
                        if let startDate = dateFormatter.dateFromString(startDateString!) {
                            
                            let endDate = createEndDateFromStartDate(startDate)
                            let fuelPrice = EiaWeeklyFuelPrice(startDate: startDate, endDate: endDate, price: amount!, seriesId: self.seriesId)
                            
                            if isAfterLatestFuelPrice(fuelPrice) {
                               latestFuelPrice = fuelPrice
                            }
                            if date.isOnOrAfter(startDate) && date.isOnOrBefore(endDate) {
                                return fuelPrice
                            }
                        }
                    }
                }
            }
        }
        
        return latestFuelPrice
    }
    
    private func getDataArray() throws -> NSArray? {
        
        let prices = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        
        if let base = prices as? NSDictionary {
            if let series = base["series"] as? NSArray {
                if let usaWeeklyData = series[0] as? NSDictionary {
                    
                    if let seriesId = usaWeeklyData["series_id"] as? String {
                        self.seriesId = seriesId
                    }
                    if let fuelPricesArray = usaWeeklyData["data"] as? NSArray {
                        return fuelPricesArray
                    }
                }
            }
        }
        
        return nil
    }
    
    private func createEndDateFromStartDate(startDate: NSDate) -> NSDate {
        
        let calendar = NSCalendar.currentCalendar()
        var endDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 6, toDate: startDate, options: NSCalendarOptions(rawValue: 0))
        endDate = calendar.dateBySettingHour(23, minute: 59, second: 59, ofDate: endDate!, options: NSCalendarOptions(rawValue: 0))
        return endDate!
    }
    
}
