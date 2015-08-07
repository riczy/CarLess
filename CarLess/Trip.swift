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
            text += "\(distance!) \(distanceUnit.abbreviation)"
        }
        return text
    }
    
    func toString() -> String {
        
        return distance == nil ? "" : "\(distance!) \(distanceUnit.abbreviation)"
    }
}
