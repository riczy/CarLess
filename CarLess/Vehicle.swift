import Foundation
import CoreData
import CoreLocation

protocol Mpg {
    
    var combinedMpg : Double? { get }
}

// A description of a passenger vehicle as defined by:
//  http://www.fueleconomy.gov/feg/ws/index.shtml
//
@objc(Vehicle)
class Vehicle: NSManagedObject, Mpg {

    @NSManaged var year: String
    @NSManaged var make: String
    @NSManaged var model: String
    @NSManaged var epaVehicleId: String
    @NSManaged var id: String
    @NSManaged var atvType: String?
    @NSManaged var comb08: NSNumber?
    @NSManaged var comb08U: NSNumber?
    @NSManaged var combA08: NSNumber?
    @NSManaged var combA08U: NSNumber?
    
    var displayDescription : String {
        get {
            return "\(year) \(make) \(model)"
        }
    }
    
    var combinedMpg : Double? {
        get {
            if comb08 != nil {
                return comb08!.doubleValue
            }
            return nil
        }
    }

}
