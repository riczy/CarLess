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
    
    var startLocation: String?
    
    var endLocation: String?
    
    var distance: Double?
    
    var distanceUnit = LengthUnit.Mile
    
    func toString() -> String {
        
        var text = ""
        
        let hasStart = startLocation != nil && !startLocation!.isEmpty
        let hasEnd = endLocation != nil && !endLocation!.isEmpty
        let hasDistance = distance != nil
        
        if hasStart {
            text += startLocation!
        }
        if hasEnd {
            if hasStart {
                text += " - "
            }
            text += endLocation!
        }
        if hasDistance {
            if hasStart && hasEnd {
                text += " ("
            }
            text += "\(distance!) \(distanceUnit.abbreviation)"
            if hasStart && hasEnd {
                text += ")"
            }
        }
        return text
    }
}
