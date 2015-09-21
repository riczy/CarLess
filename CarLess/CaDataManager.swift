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
        
        let trip = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context) as! Trip
        trip.id = NSUUID().UUIDString
        trip.distance = 0.0
        
        return trip
    }
    
    func initWaypoint() -> Waypoint {
        
        let entityDescription = NSEntityDescription.entityForName("Waypoint", inManagedObjectContext: context)
        return NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context) as! Waypoint
    }
    
    func initWaypointWithLocation(location: CLLocation, trip: Trip) -> Waypoint {
        
        let waypoint = initWaypoint()
        waypoint.trip = trip
        waypoint.setUsingLocation(location)
        return waypoint
    }
    
    func initVehicle() -> Vehicle {
        
        let entityDescription = NSEntityDescription.entityForName("Vehicle", inManagedObjectContext: context)
        let vehicle = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context) as! Vehicle
        vehicle.id = NSUUID().UUIDString
        
        return vehicle
    }
    
    // MARK: - Save
    
    func save(trip trip: Trip) {
        
        if trip.managedObjectContext!.hasChanges {
            do {
                try trip.managedObjectContext!.save()
                print(trip)
            } catch let error as NSError {
                print("Error when saving trip: \(error.localizedDescription)")
            }
        }
    }
    
    func save(vehicle vehicle: Vehicle) {
        
        if vehicle.managedObjectContext!.hasChanges {
            do {
                try vehicle.managedObjectContext!.save()
                print(vehicle)
            } catch let error as NSError {
                print("Error when saving vehicle: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Fetch
    
    func fetchTrips() -> [Trip] {
        
        return fetchTrips(limit: 100, skip: 0)
    }
    
    func fetchTrips(limit limit: Int, skip: Int) -> [Trip] {
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        let sortDescriptor = NSSortDescriptor(key: "startTimestamp", ascending: false)
        fetchRequest.includesPendingChanges = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = limit
        fetchRequest.fetchOffset = skip
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        
        var results: [Trip]?
        
        do {
            results = try context.executeFetchRequest(fetchRequest) as? [Trip]
        } catch let error as NSError {
            print("Error when fetching trips: \(error.localizedDescription)")
        }
        
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
        
        var results: [Vehicle]?
        
        do {
            results = try context.executeFetchRequest(fetchRequest) as? [Vehicle]
        } catch let error as NSError {
            print("Error when fetching vehicles: \(error.localizedDescription)")
        }
        
        return results == nil || results?.count == 0 ? nil : results![0]
    }
}
