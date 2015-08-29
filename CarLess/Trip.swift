import Foundation

class Trip {
    
    private static var _formatter: NSNumberFormatter?
    static var formatter: NSNumberFormatter {
        get {
            if _formatter == nil {
                _formatter = NSNumberFormatter()
                _formatter!.numberStyle = NSNumberFormatterStyle.DecimalStyle
                _formatter!.minimum = 0
                _formatter!.maximumFractionDigits = 2
            }
            return _formatter!
        }
    }
    
    var id: String?
    
    var startTimestamp: NSDate?
    
    var endTimestamp: NSDate?
    
    var mode: Mode?
    
    var distance: Double?
    
    var distanceUnit: LengthUnit?
    
    var logType: LogType?
    
}

// Indicates the mode of transportation that was used for a commuting trip.
//
enum Mode: String {
    
    case Walk = "Walk"
    case Bicycle = "Bicycle"
    case Rideshare = "Rideshare"
    case Bus = "Bus"
    case Train = "Train"
    
    var imageFilename: String {
        
        get {
            switch self {
            case .Walk:
                return "trans-walk"
            case .Bicycle:
                return "trans-bike"
            case .Bus:
                return "trans-bus"
            case .Train:
                return "trans-train"
            case .Rideshare:
                return "trans-rideshare"
            }
        }
    }
    
    var description: String {
        
        get {
            return self.rawValue
        }
    }
    
    static let allValues = [Walk, Bicycle, Bus, Train, Rideshare]
}

// A measurement type for identifying the unit of length for a trip's
// distance.
//
enum LengthUnit : String {
    
    case Mile = "Mile"
    
    var abbreviation: String {
        
        get {
            switch self {
            case .Mile:
                return "mi"
            }
        }
    }
    
    var description: String {
        
        get {
            return self.rawValue
        }
    }
    
    static let allValues = [ Mile ]
}

// Indicates the type of log entry made for a commuting trip.
//
enum LogType: String {
    
    case Manual = "Manual"
    case Tracked = "Tracked"
}