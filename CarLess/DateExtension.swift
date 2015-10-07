import Foundation

extension NSDate {
    
    public func isBefore(date: NSDate) -> Bool {
    
        return self.compare(date) == .OrderedAscending
    }
    
    public func isOnOrBefore(date: NSDate) -> Bool {
        
        let result = self.compare(date)
        return result == .OrderedSame || result == .OrderedAscending
    }
    
    public func isAfter(date: NSDate) -> Bool {
    
        return self.compare(date) == .OrderedDescending
    }
    
    public func isOnOrAfter(date: NSDate) -> Bool {
        
        let result = self.compare(date)
        return result == .OrderedSame || result == .OrderedDescending
    }
    
    public func monthRange() -> (startDate: NSDate, endDate: NSDate) {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Era, NSCalendarUnit.Year, NSCalendarUnit.Month], fromDate: self)
        let startDate = calendar.dateFromComponents(components)
        let monthDays = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: self)
        
        components.day = monthDays.length
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        let endDate = calendar.dateFromComponents(components)
        
        return (startDate!, endDate!)
    }
    
    public func weekRange() -> (startDate: NSDate, endDate: NSDate) {
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.YearForWeekOfYear, NSCalendarUnit.WeekOfYear], fromDate: self)
        let startDate = calendar.dateFromComponents(components)
        var endDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 6, toDate: startDate!, options: NSCalendarOptions(rawValue: 0))
        endDate = calendar.dateBySettingHour(23, minute: 59, second: 59, ofDate: endDate!, options: NSCalendarOptions(rawValue: 0))
        
        return (startDate!, endDate!)
    }
    
}
