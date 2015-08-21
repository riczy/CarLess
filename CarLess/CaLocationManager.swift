import MapKit

class CaLocationManager {
    
    static let instance = CaLocationManager()
    
    private var _locationManager: CLLocationManager! = {
        
        let manager = CLLocationManager()
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    var locationManager: CLLocationManager {
        
        get {
            return _locationManager
        }
    }
    
    
    private init() {
        
    }
    
    func requestAlwaysAuthorization() {
        
        locationManager.requestAlwaysAuthorization()
    }
    
    static func isLocationServiceAvailable() -> Bool {
        
        return CLLocationManager.locationServicesEnabled() &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Denied &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Restricted &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.NotDetermined
    }
}