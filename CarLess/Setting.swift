import Foundation
import CoreData

@objc(Setting)
class Setting: NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged private var distanceUnitCode : String
    @NSManaged var vehicle: Vehicle?
    
    var distanceUnit: LengthUnit {
        get {
            return LengthUnit(rawValue: self.distanceUnitCode)!
        }
        set {
            distanceUnitCode = newValue.rawValue
        }
    }
}
    