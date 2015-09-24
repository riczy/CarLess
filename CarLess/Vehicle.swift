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
    
    var displayDescription : String {
        get {
            return "\(year) \(make) \(model)"
        }
    }

}
