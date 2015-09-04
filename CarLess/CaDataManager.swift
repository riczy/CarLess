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
    
    func save(#trip: Trip) {
        
        trip.managedObjectContext!.save(nil)
        println(trip)
    }
    
//    func saveTrip(trip: Trip) {
//        
//        var newTrip = NSEntityDescription.insertNewObjectForEntityForName("Trip", inManagedObjectContext: context) as! NSManagedObject
//        newTrip.setValue(NSUUID().UUIDString, forKey: "id")
//        newTrip.setValue(trip.distance, forKey: "distance")
//        newTrip.setValue(trip.logType?.rawValue, forKey: "logType")
//        newTrip.setValue(trip.mode?.rawValue, forKey: "modeType")
//        newTrip.setValue(trip.startTimestamp, forKey: "startTimestamp")
//        newTrip.setValue(trip.endTimestamp, forKey: "endTimestamp")
//        newTrip.setValue(NSSet(array: trip.waypoints), forKey: "waypoints")
//        
//        
//        context.save(nil)
//        
//        println(newTrip)
//        println("Object saved")
//        
//    }
    
    func fetchAllTrips() {
        
        var request = NSFetchRequest(entityName: "Trip")
        request.returnsObjectsAsFaults = false
        
        var results:NSArray = context.executeFetchRequest(request, error: nil)! // error shouldn't be nil in long run
        if results.count > 0 {
            println("Count = \(results.count)")
            for res in results {
                println(res) 
            }
        } else {
            println("No results for Trip")
        }
    }
    
    func exampleFetch() {
        
//        var t = Trip()
//        t.distance = 32.0
//        t.distanceUnit = LengthUnit.Mile
//        t.logType = LogType.Manual
//        t.mode = Mode.Bicycle
//        t.startTimestamp = NSDate()
//        t.addWaypoint(latitude: NSDecimalNumber(string: "32.8"), longitude: NSDecimalNumber(string: "32.0"), timestamp: NSDate(), name: "hello")
//        saveTrip(t)
//        
//        t = Trip()
//        t.distance = 90.0
//        t.distanceUnit = LengthUnit.Mile
//        t.logType = LogType.Manual
//        t.mode = Mode.Walk
//        t.startTimestamp = NSDate()
//        t.addWaypoint(latitude: NSDecimalNumber(string: "90.0"), longitude: NSDecimalNumber(string: "90.0"), timestamp: NSDate(), name: "smhellow")
//        saveTrip(t)
//
//        t = Trip()
//        t.distance = 45.0
//        t.distanceUnit = LengthUnit.Mile
//        t.logType = LogType.Manual
//        t.mode = Mode.Walk
//        t.startTimestamp = NSDate()
//        t.addWaypoint(latitude: NSDecimalNumber(string: "45.0"), longitude: NSDecimalNumber(string: "45.0"), timestamp: NSDate(), name: "llo")
//        saveTrip(t)

        
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
//        fetchRequest.predicate = NSPredicate(format: "waypoint.name contains[c] %@", "hello")
        fetchRequest.fetchBatchSize = 50
        fetchRequest.sortDescriptors = [sortDescriptor]
        println(fetchRequest)
        
    }
}
