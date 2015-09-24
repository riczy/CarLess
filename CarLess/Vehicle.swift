import Foundation
import CoreData
import CoreLocation

@objc(Vehicle)
class Vehicle: NSManagedObject {

    @NSManaged var year: String
    @NSManaged var make: String
    @NSManaged var model: String
    @NSManaged var epaVehicleId: String
    @NSManaged var id: String
    @NSManaged var comb08: NSNumber?
    @NSManaged var comb08U: NSNumber?
    @NSManaged var combA08: NSNumber?
    @NSManaged var combA08U: NSNumber?
    
    var displayDescription : String {
        get {
            return "\(year) \(make) \(model)"
        }
    }

}
