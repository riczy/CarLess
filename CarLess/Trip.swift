import Foundation

class Trip {
    
    private static var _formatter: NSNumberFormatter?
    static var formatter: NSNumberFormatter {
        get {
            if _formatter == nil {
                _formatter = NSNumberFormatter()
                _formatter!.numberStyle = NSNumberFormatterStyle.DecimalStyle
                _formatter!.minimum = 0
                _formatter!.maximumFractionDigits = 1
            }
            return _formatter!
        }
    }
    
//    private var _date: NSDate = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.startOfDayForDate(NSDate())
//    
//    var date: NSDate {
//        get {
//            return _date
//        }
//        set {
//            _date = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!.startOfDayForDate(newValue)
//        }
//    }
    
    var date: NSDate?
    
    var mode: Mode?
    
    var distance: Double?
    
    var distanceUnit: LengthUnit?
    
}
