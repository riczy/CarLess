import UIKit
import MapKit

class CaMappedRouteController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var trackingButton: UIButton!
    
    private var mode = Mode.allValues.first
    
    // MARK: - UI Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.mapType = MKMapType.Standard
        mapView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        if CaLocationManager.isLocationServiceAvailable() {
            mapView.showsUserLocation = true
        } else {
            CaLocationManager.instance.requestAlwaysAuthorization()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        if mapView.showsUserLocation {
            mapView.showsUserLocation = false
        }
    }
    
    // MARK: - UI Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if identifier == CaSegue.MappedRouteToInProgress {
            if CaLocationManager.isLocationServiceAvailable() {
                return true
            } else {
                CaLocationManager.instance.requestAlwaysAuthorization()
                return false
            }
        }
        return true
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == CaSegue.MappedRouteToInProgress {
            let vc = segue.destinationViewController as! CaMappedRouteProgressController
            vc.mode = mode
        }
    }
    
    
    @IBAction
    func unwindToTripTrackingBeginning(segue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Map View Delegation
    
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let userLocationCoordinate = userLocation.coordinate
        let region = MKCoordinateRegion(center: userLocationCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    // MARK: - Location Manager Delegation
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if CaLocationManager.isLocationServiceAvailable() && !mapView.showsUserLocation {
            mapView.showsUserLocation = true
        }
    }
    
}
