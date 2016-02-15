import UIKit
import CoreData
import CoreLocation

class CaDataManager {
    
    static let instance = CaDataManager()
    
    var context: NSManagedObjectContext!
    
    
    // MARK: - Generic
    
    func rollback(managedObject: NSManagedObject) {
        
        if managedObject.hasChanges {
            managedObject.managedObjectContext!.rollback()
        }
    }
    
    func save() {

        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                NSLog("Error when saving the managed context: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Waypoints
    
    
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
    
    func fetchWaypointsForTrip(trip: Trip, limit: Int?, skip: Int?) -> [Waypoint] {
        
        let fetchRequest = NSFetchRequest(entityName: "Waypoint")
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.includesPendingChanges = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        if limit != nil {
            fetchRequest.fetchLimit = limit!
        }
        if skip != nil {
            fetchRequest.fetchOffset = skip!
        }
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        
        var results: [Waypoint]?
        
        do {
            results = try context.executeFetchRequest(fetchRequest) as? [Waypoint]
        } catch let error as NSError {
            NSLog("Error when fetching waypoints: \(error.localizedDescription)")
        }
        
        if results == nil {
            return [Waypoint]()
        }
        
        return results!
        
    }
    
    // MARK: - Trips
    
    func initTrip() -> Trip {
        
        let entityDescription = NSEntityDescription.entityForName("Trip", inManagedObjectContext: context)
        
        let trip = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context) as! Trip
        trip.id = NSUUID().UUIDString
        trip.distance = 0.0
        trip.points = 0
        
        return trip
    }
    
    func save(trip trip: Trip) {
        
        if trip.vehicle == nil {
            trip.vehicle = defaultVehicle
        }
        
        if trip.managedObjectContext!.hasChanges {
            do {
                if trip.objectID.temporaryID {
                    TripCreatePointsCalculator.calculatePointsForTrip(trip)
                }
                try trip.managedObjectContext!.save()
            } catch let error as NSError {
                NSLog("Error when saving trip: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(trip trip: Trip?) throws {
        
        if trip != nil {
            trip!.managedObjectContext?.deleteObject(trip!)
            try trip!.managedObjectContext!.save()
        }
    }
    
    
    func fetchTrips() -> [Trip] {
        
        return fetchTrips(limit: nil, skip: nil)
    }
    
    func fetchTrips(limit limit: Int?, skip: Int?) -> [Trip] {
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        let sortDescriptor = NSSortDescriptor(key: "startTimestamp", ascending: false)
        
        fetchRequest.includesPendingChanges = false
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "pending = %@", argumentArray: [false])
        
        if limit != nil {
            fetchRequest.fetchLimit = limit!
        }
        if skip != nil {
            fetchRequest.fetchOffset = skip!
        }
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        
        var results: [Trip]?
        
        do {
            results = try context.executeFetchRequest(fetchRequest) as? [Trip]
        } catch let error as NSError {
            NSLog("Error when fetching trips: \(error.localizedDescription)")
        }
        
        if results == nil {
            return [Trip]()
        }
        
        return results!
        
    }
    
    /**
     * Returns the current total reputation points that this user has. If the user
     * has no reputation points then zero is returned.
     */
    func fetchReputation() -> Int {
        
        var pointsTotal = 0
        
        let expression = NSExpressionDescription()
        expression.name = "pointsTotal";
        expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "points")])
        expression.expressionResultType = NSAttributeType.DoubleAttributeType
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        fetchRequest.predicate = NSPredicate(format: "pending = %@", argumentArray: [false])
        fetchRequest.propertiesToFetch = [expression]
        fetchRequest.resultType = .DictionaryResultType
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            let dict = results[0] as! [String:Int]
            pointsTotal = dict["pointsTotal"]!
        } catch let error as NSError {
            NSLog("Error when fetching trips: \(error.localizedDescription)")
        }
        
        return pointsTotal
    }
    
    /**
     * Returns the reputation points that the user had 7 days ago.
     */
    func fetchWeekAgoReputation() -> Int {
        
        var pointsTotal = 0
        
        let expression = NSExpressionDescription()
        expression.name = "pointsTotal";
        expression.expression =  NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "points")])
        expression.expressionResultType = NSAttributeType.DoubleAttributeType
        
        let weekago = NSDate().addDays(-7)
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        fetchRequest.predicate = NSPredicate(format: "pending = %@ and startTimestamp <= %@", argumentArray: [false, weekago])
        fetchRequest.propertiesToFetch = [expression]
        fetchRequest.resultType = .DictionaryResultType
        
        do {
            let results = try context.executeFetchRequest(fetchRequest)
            let dict = results[0] as! [String:Int]
            pointsTotal = dict["pointsTotal"]!
        } catch let error as NSError {
            NSLog("Error when fetching trips: \(error.localizedDescription)")
        }
        
        return pointsTotal
    }
    
    // MARK: - Vehicles
    
    func initVehicle() -> Vehicle {
        
        let entityDescription = NSEntityDescription.entityForName("Vehicle", inManagedObjectContext: context)
        let vehicle = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context) as! Vehicle
        vehicle.id = NSUUID().UUIDString
        
        return vehicle
    }
    
    func save(vehicle vehicle: Vehicle) {
        
        if vehicle.managedObjectContext!.hasChanges {
            do {
                try vehicle.managedObjectContext!.save()
            } catch let error as NSError {
                NSLog("Error when saving vehicle: \(error.localizedDescription)")
            }
        }
    }
   
    func fetchVehicles() -> [Vehicle] {
        
        let fetchRequest = NSFetchRequest(entityName: "Vehicle")
        fetchRequest.includesPendingChanges = false
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        
        var results: [Vehicle]?
        
        do {
            results = try context.executeFetchRequest(fetchRequest) as? [Vehicle]
        } catch let error as NSError {
            NSLog("Error when fetching vehicles: \(error.localizedDescription)")
        }
        
        return results == nil ? [Vehicle]() : results!
    }
    
    // MARK: - Settings
    
    private var _defaultDistanceUnit: LengthUnit?
    var defaultDistanceUnit: LengthUnit {
        get {
            if _defaultDistanceUnit == nil {
                if let unit = fetchSettings()?.distanceUnit {
                    _defaultDistanceUnit = unit
                } else {
                    _defaultDistanceUnit = LengthUnit.Mile
                    saveDefaultSetting(distanceUnit: _defaultDistanceUnit!)
                }
            }
            return _defaultDistanceUnit!
        }
    }
    
    private var _defaultVehicle: Vehicle?
    var defaultVehicle: Vehicle? {
        get {
            if _defaultVehicle == nil {
                if let vehicle = fetchSettings()?.vehicle {
                    _defaultVehicle = vehicle
                }
            }
            return _defaultVehicle
        }
    }
    
    private func initSetting() -> Setting {
        
        let entityDescription = NSEntityDescription.entityForName("Setting", inManagedObjectContext: context)
        let settings = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: context) as! Setting
        settings.id = NSUUID().UUIDString
        
        return settings
    }
    
    func save(settings settings: Setting) {
        
        if settings.managedObjectContext!.hasChanges {
            do {
                try settings.managedObjectContext!.save()
                _defaultDistanceUnit = settings.distanceUnit
                _defaultVehicle = settings.vehicle
            } catch let error as NSError {
                NSLog("Error when saving vehicle: \(error.localizedDescription)")
            }
        }
    }
    
    func saveDefaultSetting(vehicle vehicle: Vehicle?) {
        
        let settings = getSettings()
        settings.vehicle = vehicle
        save(settings: settings)
    }
    
    func saveDefaultSetting(distanceUnit unit: LengthUnit) {
        
        let settings = getSettings()
        settings.distanceUnit = unit
        save(settings: settings)
    }
    
    private func getSettings() -> Setting {
        
        var settings = self.fetchSettings()
        if settings == nil {
            settings = initSetting()
        }
        return settings!
    }
    
    func fetchSettings() -> Setting? {
        
        let fetchRequest = NSFetchRequest(entityName: "Setting")
        fetchRequest.includesPendingChanges = false
        fetchRequest.fetchLimit = 1
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        
        var results: [Setting]?
        
        do {
            results = try context.executeFetchRequest(fetchRequest) as? [Setting]
        } catch let error as NSError {
            NSLog("Error when fetching settings: \(error.localizedDescription)")
        }
        
        return results == nil || results?.count == 0 ? nil : results![0]
    }
    
    func countTripsUsedByVehicle(vehicle: Vehicle?) -> Int {
        
        if vehicle == nil {
            return 0
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        fetchRequest.includesPendingChanges = false
        fetchRequest.resultType = NSFetchRequestResultType.CountResultType
        
        let count = context.countForFetchRequest(fetchRequest, error: nil)
        if count == NSNotFound {
            NSLog("countTripsUsedByVehicles encountered an error.")
            return 0
        }
        
        return count
    }
    

}
