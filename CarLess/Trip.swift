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
    
    var route: ManualRoute = ManualRoute()
    
}

struct ManualRoute {
    
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
    
    var routeName: String?
    var distance: Double?
    var distanceUnit = LengthUnit.Mile
    
    func toLongString() -> String {
        
        var text = ""
        
        let hasName = routeName != nil && !routeName!.isEmpty
        let hasDistance = distance != nil
        
        if hasName {
            text += routeName!
        }
        if hasDistance {
            if hasName {
                text += " @ "
            }
            text += ManualRoute.formatter.stringFromNumber(distance!)!
            text += " \(distanceUnit.abbreviation)"
        }
        return text
    }
    
    func toString() -> String {
        
        return distance == nil ? "" : "\(ManualRoute.formatter.stringFromNumber(distance!)!) \(distanceUnit.abbreviation)"
    }
}
