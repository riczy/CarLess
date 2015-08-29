import MapKit

class CaLocationManager {
    
    static let instance = CaLocationManager()
    
    private var _locationManager = CLLocationManager()
    
    var locationManager: CLLocationManager {
        
        get {
            return _locationManager
        }
    }
        
    private init() {
    }
    
    static func startUpdatingLocation() {
        
        instance.locationManager.startUpdatingLocation()
    }
    
    static func stopUpdatingLocation() {
        
        instance.locationManager.stopUpdatingLocation()
    }
    
    static func setActivityType(activityType: CLActivityType, andAccuracy accuracy: CLLocationAccuracy) {
        
        instance.locationManager.activityType = activityType
        instance.locationManager.desiredAccuracy = accuracy
    }
    
    static func requestAlwaysAuthorization() {
        
        instance.locationManager.requestAlwaysAuthorization()
    }
    
    static func isLocationServiceAvailable() -> Bool {
        
        return CLLocationManager.locationServicesEnabled() &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Denied &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Restricted &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.NotDetermined
    }
}