import UIKit
import MapKit

class CaMappedRouteController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var trackingButton: UIButton!
    
    lazy private var locationManager: CLLocationManager! = {
            let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    private var mode = Mode.allValues.first
    private var isTracking = false
    private var locations = [MKPointAnnotation]()
    
    // MARK: - UI Lifecycle
    
    override func viewDidLoad() {
        
        println("viewDidLoad")
        super.viewDidLoad()
        
        mapView.mapType = MKMapType.Standard
        mapView.delegate = self
        
        trackingButton.addTarget(self, action: "toggleTracking:", forControlEvents: UIControlEvents.TouchUpInside)
        if isTracking {
            showStopTrackingButton()
        } else {
            showStartTrackingButton()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        println("viewDidAppear")
        super.viewDidAppear(animated)
        if isLocationServicesAvailable() {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        println("viewDidDisappear")
        super.viewDidDisappear(animated)
        if mapView.showsUserLocation {
            mapView.showsUserLocation = false
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
        
        println("mapView: didUpdateUserLocation: - \(userLocation.coordinate.latitude), \(userLocation.coordinate.longitude)")
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let userLocationCoordinate = userLocation.coordinate
        let region = MKCoordinateRegion(center: userLocationCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    // MARK: - Location Manager Delegation
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if isLocationServicesAvailable() && !mapView.showsUserLocation {
            mapView.showsUserLocation = true
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {

        println("locationManager: didUpdateToLocation: fromLocation: - \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        // Add another annotation to the map.
        let annotation = MKPointAnnotation()
        annotation.coordinate = newLocation.coordinate
        
        // Also add to our map so we can remove old values later
        locations.append(annotation)
        
        // Remove values if the array is too big
        while locations.count > 100 {
            let annotationToRemove = locations.first!
            locations.removeAtIndex(0)
            
            // Also remove from the map
            mapView.removeAnnotation(annotationToRemove)
        }
        
        if UIApplication.sharedApplication().applicationState == .Active {
            mapView.showAnnotations(locations, animated: true)
        } else {
            NSLog("App is backgrounded. New location is %@", newLocation)
        }}
    
    
    // MARK: - Private functions
    
    private func isLocationServicesAvailable() -> Bool {
        
        return CLLocationManager.locationServicesEnabled() &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Denied &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Restricted &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.NotDetermined
    }
    
    func toggleTracking(sender: UIButton) {
        
        if isTracking {
            stopTracking()
        } else {
            startTracking()
        }
    }
    
    private func startTracking() {
        
        if isLocationServicesAvailable() {
            let locationSettings = getActivityTypeAndAccuracyForMode()
            locationManager.activityType = locationSettings.activityType
            locationManager.desiredAccuracy = locationSettings.accuracy
            locationManager.startUpdatingLocation()
            showStopTrackingButton()
            isTracking = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func stopTracking() {
        
        // display cancel or continue alert
        locationManager.stopUpdatingLocation()
        showStartTrackingButton()
        isTracking = false
    }
    
    private func getActivityTypeAndAccuracyForMode() -> (activityType: CLActivityType, accuracy: CLLocationAccuracy) {
        
        if mode == Mode.Bicycle || mode == Mode.Walk {
            return (CLActivityType.Fitness, kCLLocationAccuracyNearestTenMeters)
        } else if mode == Mode.Bus || mode == Mode.Rideshare {
            return (CLActivityType.AutomotiveNavigation, kCLLocationAccuracyNearestTenMeters)
        } else if mode == Mode.Train {
            return (CLActivityType.OtherNavigation, kCLLocationAccuracyHundredMeters)
        }
        return (CLActivityType.Other, kCLLocationAccuracyKilometer)
    }
    
    private func showStartTrackingButton() {
        
        trackingButton.setTitle("Start", forState: UIControlState.Normal)
        trackingButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        trackingButton.backgroundColor = UIColor.blueColor()
        trackingButton.layer.borderColor = UIColor.blueColor().CGColor
        trackingButton.layer.cornerRadius = 8
        trackingButton.layer.borderWidth = 1
    }
    
    private func showStopTrackingButton() {
        
        trackingButton.setTitle("Stop", forState: UIControlState.Normal)
        trackingButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        trackingButton.backgroundColor = UIColor.redColor()
        trackingButton.layer.borderColor = UIColor.whiteColor().CGColor
        trackingButton.layer.cornerRadius = 8
        trackingButton.layer.borderWidth = 1
    }

}
