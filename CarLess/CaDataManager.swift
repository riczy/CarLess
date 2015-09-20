import UIKit
import CoreData
import CoreLocation

class CaDataManager {
    
    static let instance = CaDataManager()
    
    var context: NSManagedObjectContext {
        get {
            return (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        }
    }
    
    private init() {
    }
    
    func getDistanceUnitDisplaySetting() -> LengthUnit {
        
        return LengthUnit.Mile
    }
    
    // MARK: - Entity Instance
    
    func initTrip() -> Trip {
        
        let entityDescription = NSEntityDescription.entityForName("Trip", inManagedObjectContext: context)
        
        var trip = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context) as! Trip
        trip.id = NSUUID().UUIDString
        trip.distance = 0.0
        
        return trip
    }
    
    func initWaypoint() -> Waypoint {
        
        let entityDescription = NSEntityDescription.entityForName("Waypoint", inManagedObjectContext: context)
        return NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context) as! Waypoint
    }
    
    func initWaypointWithLocation(location: CLLocation, trip: Trip) -> Waypoint {
        
        var waypoint = initWaypoint()
        waypoint.trip = trip
        waypoint.setUsingLocation(location)
        return waypoint
    }
    
    func initVehicle() -> Vehicle {
        
        let entityDescription = NSEntityDescription.entityForName("Vehicle", inManagedObjectContext: context)
        var vehicle = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context) as! Vehicle
        vehicle.id = NSUUID().UUIDString
        
        return vehicle
    }
    
    // MARK: - Save
    
    func save(#trip: Trip) {
        
        trip.managedObjectContext!.save(nil)
        println(trip)
    }
    
    func save(#vehicle: Vehicle) {
        
        vehicle.managedObjectContext!.save(nil)
        println(vehicle)
    }
    
    // MARK: - Fetch
    
    func fetchTrips() -> [Trip] {
        
        return fetchTrips(limit: 100, skip: 0)
    }
    
    func fetchTrips(#limit: Int, skip: Int) -> [Trip] {
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        let sortDescriptor = NSSortDescriptor(key: "startTimestamp", ascending: false)
        fetchRequest.includesPendingChanges = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = limit
        fetchRequest.fetchOffset = skip
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        
        var results:[Trip]? = context.executeFetchRequest(fetchRequest, error: nil) as? [Trip]
        
        if results == nil {
            return [Trip]()
        }
        
        return results!
        
    }
    
    func fetchVehicle() -> Vehicle? {
        
        let fetchRequest = NSFetchRequest(entityName: "Vehicle")
        fetchRequest.includesPendingChanges = false
        fetchRequest.fetchLimit = 1
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectIDResultType
        
        let results: [Vehicle]? = context.executeFetchRequest(fetchRequest, error: nil) as? [Vehicle]
        
        return results == nil || results?.count == 0 ? nil : results![0]
    }
}
