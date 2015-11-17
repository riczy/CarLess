import Foundation
import CoreData
import CoreLocation

@objc(Waypoint)
class Waypoint: NSManagedObject {

    @NSManaged var altitude: NSNumber
    @NSManaged var course: NSNumber
    @NSManaged var horizontalAccuracy: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var speed: NSNumber
    @NSManaged var timestamp: NSDate
    @NSManaged var trip: Trip
    @NSManaged var verticalAccuracy: NSNumber
    
    @NSManaged var discard: Bool
    @NSManaged var receivedTimestamp: NSDate?
    
    /*
     * Returns the coordinate of the location.
     */
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.latitude.doubleValue, longitude: self.longitude.doubleValue)
        }
    }
    
    /*
     *
     */
    func set(latitude latitude: NSNumber, longitude: NSNumber, altitude: NSNumber, horizontalAccuracy: NSNumber, verticalAccuracy: NSNumber, course: NSNumber, speed: NSNumber, timestamp: NSDate) {
        
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.horizontalAccuracy = horizontalAccuracy
        self.verticalAccuracy = verticalAccuracy
        self.course = course
        self.speed = speed
        self.timestamp = timestamp
        
        self.discard = false
    }
    
    /*
     *
     */
    func setUsingLocation(location: CLLocation) {
        
        self.set(latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            altitude: location.altitude,
            horizontalAccuracy: location.horizontalAccuracy,
            verticalAccuracy: location.verticalAccuracy,
            course: location.course,
            speed: location.speed,
            timestamp: location.timestamp)
    }

}
