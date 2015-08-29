import UIKit
import CoreData

class CaDataManager {
    
    static let instance = CaDataManager()
    
    private var context: NSManagedObjectContext = {
    
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.managedObjectContext!
    }()
    
    private init() {
    }
    
    func saveTrip(trip: Trip) {
        
        var newTrip = NSEntityDescription.insertNewObjectForEntityForName("Trip", inManagedObjectContext: context) as! NSManagedObject
        newTrip.setValue(NSUUID().UUIDString, forKey: "id")
        newTrip.setValue(trip.distance, forKey: "distance")
        newTrip.setValue(trip.distanceUnit?.rawValue, forKey: "distanceUnit")
        newTrip.setValue(trip.logType?.rawValue, forKey: "logType")
        newTrip.setValue(trip.mode?.rawValue, forKey: "modeType")
        newTrip.setValue(trip.startTimestamp, forKey: "startTimestamp")
        newTrip.setValue(trip.endTimestamp, forKey: "endTimestamp")
        
        context.save(nil)
        
        println(newTrip)
        println("Object saved")
        
    }
    
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
}
