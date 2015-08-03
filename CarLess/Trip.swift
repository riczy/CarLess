import Foundation

class Trip {
    
    private var _date: NSDate = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.startOfDayForDate(NSDate())
    
    var date: NSDate {
        get {
            return _date
        }
        set {
            _date = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.startOfDayForDate(newValue)
        }
    }
    
    var mode: Mode = Mode.Bicycle
    
}