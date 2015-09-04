import Foundation
import CoreData
import CoreLocation

@objc(Trip)
class Trip: NSManagedObject {

    @NSManaged var distance: NSNumber
    @NSManaged var endTimestamp: NSDate?
    @NSManaged var id: String
    @NSManaged private var logTypeCode: String
    @NSManaged private var modeTypeCode: String
    @NSManaged var startTimestamp: NSDate
    @NSManaged var waypoints: NSMutableSet
    
    var logType: LogType {
        get {
            return LogType(rawValue: self.logTypeCode)!
        }
        set {
            logTypeCode = newValue.rawValue
        }
    }
    
    var modeType: Mode {
        get {
            return Mode(rawValue: self.modeTypeCode)!
        }
        set {
            modeTypeCode = newValue.rawValue
        }
    }
    
    func getDistanceInUnit(unit: LengthUnit) -> Double? {
        
        return distance.doubleValue * unit.conversionFactor
    }
    
    func setDistance(distance: NSNumber, hasUnitType unit: LengthUnit) {
        
        // Convert distance to meters
        self.distance = distance.doubleValue / unit.conversionFactor
    }
}
