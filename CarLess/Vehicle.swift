import Foundation
import CoreData
import CoreLocation

@objc(Vehicle)
class Vehicle: NSManagedObject {

    @NSManaged var year: NSNumber
    @NSManaged var make: String
    @NSManaged var model: String
    @NSManaged var trim: String
    @NSManaged var epaVehicleId: String
    @NSManaged var avgMpg: NSNumber
    @NSManaged var id: String

}
