import UIKit
import CoreData
import CoreLocation

class CaDataManager {
    
    static let instance = CaDataManager()
    
    var context: NSManagedObjectContext
    
    private init() {
        
        guard let modelURL = NSBundle.mainBundle().URLForResource("CarLess", withExtension: "momd") else {
            fatalError("Error loading model from bundle.")
        }
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing managed object model from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex - 1]
            let storeURL = docURL.URLByAppendingPathComponent("DataModel.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
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
        print("waypoint = \(waypoint)")
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
                print("\(trip), waypoints.count = \(trip.waypoints.count)")
                try trip.managedObjectContext!.save()
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
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        
        var results: [Vehicle]?
        
        do {
            results = try context.executeFetchRequest(fetchRequest) as? [Vehicle]
        } catch let error as NSError {
            print("Error when fetching vehicles: \(error.localizedDescription)")
        }
        
        return results == nil || results?.count == 0 ? nil : results![0]
    }
}
