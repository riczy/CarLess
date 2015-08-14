import UIKit
import MapKit

class CaMappedRouteController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startTrackingButton: UIButton!
    
    var locationManager = CLLocationManager()
    
    private var startLocation: CLLocationCoordinate2D?
    private var endLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapType = MKMapType.Standard
        mapView.delegate = self
        
//        mapView.showsUserLocation = true
//        
//        let userLocation = mapView.userLocation?.location
//        println("coordinate= \(userLocation?.coordinate)")
//        println("altitude= \(userLocation?.altitude)")
//        println("timestamp= \(userLocation?.timestamp)")
        
        
//        locationManager = CLLocationManager()
//        locationManager.requestAlwaysAuthorization()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.distanceFilter = 500 // meters
//        locationManager.startMonitoringSignificantLocationChanges()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        println("viewDidAppear")
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        println("viewDidDisappear")
        super.viewDidDisappear(animated)
        if mapView.showsUserLocation {
            mapView.showsUserLocation = false
        }
    }
    
    func checkLocationAuthorizationStatus() {
    
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Map View Delegation
    func mapView(mapView: MKMapView!, didFailToLocateUserWithError error: NSError!) {
        println("didFailToLocateUserWithError")
    }
    
    func mapViewWillStartLocatingUser(mapView: MKMapView!) {
        println("mapViewWillStartLocatingUser")
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        println("mapView: didUpdateUserLocation:")
        
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let userLocationCoordinate = userLocation.coordinate
        let region = MKCoordinateRegion(center: userLocationCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        println("locations size = \(locations.count)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
