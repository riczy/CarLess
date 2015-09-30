import Foundation

struct EiaWeeklyFuelPrice: CustomStringConvertible {
    
    var startDate: NSDate
    var endDate: NSDate
    var price: Double
    var seriesId: String?
    
    var description: String {
        get {
            return "\(price), \(startDate) - \(endDate), \(seriesId)"
        }
    }
}

class EiaWeeklyFuelPriceParser: NSObject {
    
    private var data: NSData
    private var seriesId: String?
    
    init(data: NSData) {
        
        self.data = data
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
                            
                            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
                            let endDate = calendar?.dateByAddingUnit(NSCalendarUnit.Day, value: 6, toDate: startDate, options: NSCalendarOptions(rawValue: 0))
                            
                            if date.isOnOrAfter(startDate) && date.isOnOrBefore(endDate!) {
                                return EiaWeeklyFuelPrice(startDate: startDate, endDate: endDate!, price: amount!, seriesId: self.seriesId)
                            }
                        }
                    }
                }
            }
        }
        
        return nil
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
    
}
