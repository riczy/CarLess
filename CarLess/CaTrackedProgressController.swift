import UIKit
import MapKit

class CaTrackedProgressController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - UI Properties

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceTitleLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var modeTitleLabel: UILabel!
    @IBOutlet weak var modeImageView: UIImageView!
    
    // MARK: - Properties
    
    var mode: Mode? {
        get {
            return trip.mode
        }
        set {
            trip.mode = newValue
        }
    }
    
    private var trip = Trip()
    
    private var distanceTraveled: Double {
        get {
            return trip.distance == nil ? 0.0 : trip.distance!
        }
        set {
            let formattedDistance = CaFormatter.distance.stringFromNumber(newValue)
            if formattedDistance == nil {
                // This should never be nil.
                distanceValueLabel.text = ""
                trip.distance = nil
            } else {
                distanceValueLabel.text = formattedDistance!
                trip.distance = CaFormatter.distance.numberFromString(formattedDistance!)?.doubleValue
            }
        }
    }
    
    private var lastLocation: CLLocation!
    
    private var locations = [MKPointAnnotation]()
    
    lazy private var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeStyle()
        reset()
        
        modeImageView?.image = UIImage(named: mode!.imageFilename)
        
        //renderStopButton()
        stopButton.addTarget(self, action: "signalStopTracking", forControlEvents: UIControlEvents.TouchUpInside)

        mapView.mapType = MKMapType.Standard
        mapView.delegate = self
        
        startTracking()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        if !mapView.showsUserLocation {
            mapView.showsUserLocation = true
        }
    }
    
    override func viewDidDisappear(animated: Bool) {

        // DO I need to do this??
        
        super.viewDidDisappear(animated)
        if mapView.showsUserLocation {
            mapView.showsUserLocation = false
        }
    }
    
    // MARK: - View Initializations
    
    private func initializeStyle() {
        
        view.backgroundColor = CaLogStyle.SegmentBarBgColor
        modeTitleLabel.textColor = CaLogStyle.ViewLabelColor
        distanceTitleLabel.textColor = CaLogStyle.ViewLabelColor
        distanceValueLabel.textColor = CaLogStyle.ViewFieldColor
    }

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == CaSegue.TrackedProgressToSummary {
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
            println("long=\(lastLocation.coordinate.longitude), lat=\(lastLocation.coordinate.latitude), distance = \(distanceTraveled)")
        }
    }
    
    // MARK: - Scene Actions

    private func startTracking() {
        
        if CaLocationManager.isLocationServiceAvailable() {
            mapView.showsUserLocation = true
            let locationSettings = getActivityTypeAndAccuracyForMode()
            locationManager.activityType = locationSettings.activityType
            locationManager.desiredAccuracy = locationSettings.accuracy
            locationManager.startUpdatingLocation()
            trip.startTimestamp = NSDate()
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
        trip.endTimestamp = NSDate()
        performSegueWithIdentifier(CaSegue.TrackedProgressToSummary, sender: self)
    }
    
    // MARK: - Miscellaneous
    
    private func reset() {
        
        lastLocation = nil
        locations.removeAll(keepCapacity: false)
        trip.distance = 0.0
        trip.distanceUnit = LengthUnit.Mile
        trip.endTimestamp = nil
        trip.logType = LogType.Tracked
        trip.startTimestamp = nil
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
