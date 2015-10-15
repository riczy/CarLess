import Foundation

/*
 * Modes of transportation for a commuting trip.
 */
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

/* 
 * A measurement type for identifying the unit of distance for a trip.
 */
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
    
    static let userValues = [ Mile, Kilometer ]
}

/*
 * Indicates the type of log entry made for a commuting trip.
 */
enum LogType: String {
    
    case Manual = "Manual"
    case Tracked = "Tracked"
}

/*
 * Standard formatters to consistently display and convert strings into
 * the relevant data type.
 */
struct CaFormatter {
    
    static var distance: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.minimum = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()

    static var decimalDisplay: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.minimum = 0
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    
    static var timestamp: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return formatter
    }()
    
    static var money: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.roundingMode = NSNumberFormatterRoundingMode.RoundHalfUp
        return formatter
    }()
    
}

