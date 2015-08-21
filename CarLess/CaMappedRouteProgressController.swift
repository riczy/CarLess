import UIKit
import MapKit

class CaMappedRouteProgressController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var progressView: CaTripRouteProgressView!
    @IBOutlet weak var stopButton: UIButton!
    
    var mode: Mode!
    
    private var locations = [MKPointAnnotation]()
    private var startTimestamp: NSDate!
    
    lazy private var locationManager: CLLocationManager! = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        renderStopButton()
        stopButton.addTarget(self, action: "signalStopTracking", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        startTracking()
    }

    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = newLocation.coordinate
        locations.append(annotation)
        println("location update: long=\(newLocation.coordinate.longitude), lat=\(newLocation.coordinate.latitude)")
    }
    

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
        performSegueWithIdentifier(CaSegue.MappedRouteProgressToSummary, sender: self)
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
        //stopButton.layer.borderColor = UIColor.whiteColor().CGColor
        stopButton.layer.cornerRadius = 2
        stopButton.layer.borderWidth = 1
    }

}
