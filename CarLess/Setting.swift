import Foundation
import CoreData

@objc(Setting)
class Setting: NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged private var distanceUnitCode : String?
    @NSManaged var vehicle: Vehicle?
    
    var distanceUnit: LengthUnit? {
        get {
            if distanceUnitCode != nil {
                if let unit = LengthUnit(rawValue: self.distanceUnitCode!) {
                    return unit
                }
            }
            return nil
        }
        set {
            distanceUnitCode = newValue?.rawValue
        }
    }
}
    