import UIKit
import MapKit

class CaTrackedProgressController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var modeValueLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    
    var mode: Mode!
    
    private var distanceTraveled: Double = 0.0 {
        didSet {
            distanceValueLabel.text! = "\(self.distanceTraveled)"
        }
    }
    
    private var lastLocation: CLLocation!
    
    private var locations = [MKPointAnnotation]()
    
    private var startTimestamp: NSDate!
    
    lazy private var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    // MARK: - View Events
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        modeValueLabel.text! = mode.description
        distanceValueLabel.text! = "\(distanceTraveled)"
        
        //renderStopButton()
        stopButton.addTarget(self, action: "signalStopTracking", forControlEvents: UIControlEvents.TouchUpInside)

        mapView.mapType = MKMapType.Standard
        mapView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        if CaLocationManager.isLocationServiceAvailable() {
            mapView.showsUserLocation = true
            startTracking()
        } else {
            CaLocationManager.instance.requestAlwaysAuthorization()
        }
    }

    override func viewDidDisappear(animated: Bool) {

        // DO I need to do this??
        
        super.viewDidDisappear(animated)
        if mapView.showsUserLocation {
            mapView.showsUserLocation = false
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == CaSegue.TrackedProgressToSummary {
            var trip = Trip()
            trip.mode = self.mode
            trip.date = self.startTimestamp
            trip.distance = self.distanceTraveled
            trip.distanceUnit = LengthUnit.Mile
            let vc = segue.destinationViewController as! CaTrackedSummaryController
            vc.trip = trip
        }
    }


    // MARK: - Map View Delegation
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        
        let span = MKCoordinateSpanMake(0.03, 0.03)
        let userLocationCoordinate = userLocation.coordinate
        let region = MKCoordinateRegion(center: userLocationCoordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
   
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        if lastLocation == nil {
            lastLocation = locations.first as! CLLocation
        } else {
            let newestLocation = locations.last as! CLLocation
            distanceTraveled += lastLocation.distanceFromLocation(newestLocation) + 0.1
            lastLocation = newestLocation
            println("lastLocation = long=\(lastLocation.coordinate.longitude), lat=\(lastLocation.coordinate.latitude)")
            println("distance travelled = \(distanceTraveled)")
        }
    }
    
    // MARK: - Scene Actions

    private func startTracking() {
        
        if CaLocationManager.isLocationServiceAvailable() {
            let locationSettings = getActivityTypeAndAccuracyForMode()
            locationManager.activityType = locationSettings.activityType
            locationManager.desiredAccuracy = locationSettings.accuracy
            locationManager.startUpdatingLocation()
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func signalStopTracking() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to stop this trip's mapping?", preferredStyle: UIAlertControllerStyle.Alert)
        let stopAction = UIAlertAction(title: "Yes, I'm finished", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.stopTracking()
        }
        let continueAction = UIAlertAction(title: "No, Continue", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in }
        alert.addAction(stopAction)
        alert.addAction(continueAction)
        presentViewController(alert, animated: true) { () -> Void in }
    }
    
    private func stopTracking() {
        
        locationManager.stopUpdatingLocation()
        performSegueWithIdentifier(CaSegue.TrackedProgressToSummary, sender: self)
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
    
    private func renderStopButton() {
        
        stopButton.setTitle("STOP", forState: UIControlState.Normal)
        stopButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        stopButton.backgroundColor = UIColor(red: 254.0/255.0, green: 73.0/255.0, blue: 2.0/255.0, alpha: 1.0)
        stopButton.layer.borderColor = UIColor.whiteColor().CGColor
        stopButton.layer.cornerRadius = 2
        stopButton.layer.borderWidth = 1
    }

}
