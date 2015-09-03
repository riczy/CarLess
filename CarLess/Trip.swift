import Foundation

class Trip {
    
    var id: String?
    
    var startTimestamp: NSDate?
    
    var endTimestamp: NSDate?
    
    var mode: Mode?
    
    var distance: Double?
    
    var logType: LogType?
    
    var waypoints: [Waypoint]?
    
    func addWaypoint(waypoint: Waypoint) {
        
        if waypoints == nil {
            waypoints = [Waypoint()]
        }
        waypoints!.append(waypoint)
    }
    
    func addWaypoint(#latitude: Double, longitude: Double, timestamp: NSDate, name: String?) {
            
        addWaypoint(Waypoint(latitude: latitude, longitude: longitude, timestamp: timestamp, name: name))
    }
    
    func getDistanceInUnit(unit: LengthUnit) -> Double? {
        
        return distance == nil ? nil : distance! * unit.conversionFactor
    }
    
    func setDistance(distance: Double?, unitType unit: LengthUnit) {
        
        // Convert distance to meters
        self.distance = distance == nil ? nil : distance! / unit.conversionFactor
    }
    
}

class Waypoint {
    
    var latitude: Double?
    
    var longitude: Double?
    
    var timestamp: NSDate?
    
    var name: String?
    
    init() {
        
    }
    
    convenience init(latitude: Double, longitude: Double, timestamp: NSDate, name: String?) {
        
        self.init()
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.name = name
    }
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
    case Meter = "Meter"
    case Kilometer = "Kilometer"
    
    var abbreviation: String {
        
        get {
            switch self {
            case .Mile:
                return "mi"
            case .Meter:
                return "m"
            case .Kilometer:
                return "km"
            }
        }
    }
    
    // The conversion factor need to convert this unit to a meter unit or vice
    // versa.
    //
    // If given a measurement in meters then divide by the conversionFactor
    // to get the desired unit. 
    //
    //     Unit / conversionFactor = Meter
    //
    // If given a measurement in the unit then multiply by the conversionFactor
    // to get meters.
    //
    //     Meter * conversionFactor = Unit
    //
    var conversionFactor: Double {
        
        get {
            switch self {
            case .Mile:
                return 0.00062137
            case .Meter:
                return 1.0
            case .Kilometer:
                return 0.001
            }
        }
    }
    
    var description: String {
        
        get {
            return self.rawValue
        }
    }
    
    static let allValues = [ Mile, Meter, Kilometer ]
}

// Indicates the type of log entry made for a commuting trip.
//
enum LogType: String {
    
    case Manual = "Manual"
    case Tracked = "Tracked"
}

struct CaFormatter {
    
    private static var _distance: NSNumberFormatter?
    static var distance: NSNumberFormatter {
        get {
            if _distance == nil {
                _distance = NSNumberFormatter()
                _distance!.numberStyle = NSNumberFormatterStyle.DecimalStyle
                _distance!.minimum = 0
                _distance!.maximumFractionDigits = 2
            }
            return _distance!
        }
    }
    
    private static var _timestamp: NSDateFormatter?
    static var timestamp: NSDateFormatter {
        get {
            if _timestamp == nil {
                _timestamp = NSDateFormatter()
                _timestamp!.dateStyle = NSDateFormatterStyle.ShortStyle
                _timestamp!.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            return _timestamp!
        }
    }
    
}

