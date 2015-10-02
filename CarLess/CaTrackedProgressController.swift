import UIKit
import CoreLocation
import MapKit

class CaTrackedProgressController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - UI Properties

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceTitleLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var modeTitleLabel: UILabel!
    @IBOutlet weak var modeImageView: UIImageView!
    private var stopButton: UIButton!
    
    // MARK: - Properties
    
    var mode: Mode!
    private var trip: Trip!
    
    private var distanceTraveled: Double {
        get {
            return trip.distance.doubleValue
        }
        set {
            trip.distance = newValue
            distanceValueLabel.text = CaFormatter.distance.stringFromNumber(trip.getDistanceInUnit(CaDataManager.instance.defaultDistanceUnit))
        }
    }
    
    private var lastLocation: CLLocation!
    private var nextToLastLocation: CLLocation!
    
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
        renderStopButton()
        
        modeImageView?.image = UIImage(named: mode.imageFilename)

        mapView.mapType = MKMapType.Standard
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.rotateEnabled = true
        mapView.pitchEnabled = false
        mapView.delegate = self
        
        startTracking()
    }
    
    
    // MARK: - View Initializations
    
    private func initializeStyle() {
        
        view.backgroundColor = CaLogStyle.ViewBgColor
        modeTitleLabel.textColor = CaLogStyle.ViewLabelColor
        distanceTitleLabel.textColor = CaLogStyle.ViewLabelColor
        distanceValueLabel.textColor = CaLogStyle.ViewFieldColor
    }

    
    private func renderStopButton() {
        
        stopButton = CaComponent.createButton(title: "Stop", color: CaLogStyle.StopButtonColor, bgColor: CaLogStyle.StopButtonBgColor, borderColor: CaLogStyle.StopButtonBorderColor)
        self.view.addSubview(stopButton)
        
        
        view.addConstraint(NSLayoutConstraint(item: stopButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: stopButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: -20.0))
        view.addConstraint(NSLayoutConstraint(item: stopButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonWidth))
        view.addConstraint(NSLayoutConstraint(item: stopButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonHeight))
        
        stopButton.addTarget(self, action: "signalStopTracking", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == CaSegue.TrackedProgressToSummary {
            let vc = segue.destinationViewController as! CaTrackedSummaryController
            vc.trip = trip
        }
    }
    
    // MARK: - Map View Delegation
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {

        let span = MKCoordinateSpanMake(0.009, 0.009)
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        // There is only one overlay on this map therefore no checking of
        // overlay done.
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = CaLogStyle.MapRouteLineColor
        polylineRenderer.lineWidth = CaLogStyle.MapRouteLineWidth
        return polylineRenderer
    }
    
    // MARK: - Location Manager Delegation
   
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if lastLocation == nil {
            
            lastLocation = locations.first!
            addTripWaypoint(lastLocation)
        } else {
            
            let newestLocation = locations.first!
            let newestDistanceTraveled = lastLocation.distanceFromLocation(newestLocation)
            if newestDistanceTraveled > 0 {
                distanceTraveled += newestDistanceTraveled
                nextToLastLocation = lastLocation
                lastLocation = newestLocation
                addTripWaypoint(newestLocation)
                print("long=\(lastLocation.coordinate.longitude), lat=\(lastLocation.coordinate.latitude), step dist = \(newestDistanceTraveled), total dist = \(distanceTraveled)")
            }
            
            if lastLocation != nil && nextToLastLocation != nil {
                var stepCoordinates = [lastLocation.coordinate, nextToLastLocation.coordinate]
                mapView.addOverlay(MKPolyline(coordinates: &stepCoordinates, count: stepCoordinates.count))
            }
        }
    }
    
    
    // MARK: - Scene Actions

    private func startTracking() {
        
        if CaLocationManager.isLocationServiceAvailable() {
            
            mapView.showsUserLocation = true
            
            trip = CaDataManager.instance.initTrip()
            trip.distance = 0.0
            trip.endTimestamp = nil
            trip.logType = LogType.Tracked
            trip.modeType = mode
            trip.startTimestamp = NSDate()
            trip.vehicle = CaDataManager.instance.defaultVehicle
            
            lastLocation = nil
            nextToLastLocation = nil
            
            let locationSettings = getActivityTypeAndAccuracyForMode()
            locationManager.activityType = locationSettings.activityType
            locationManager.desiredAccuracy = locationSettings.accuracy
            locationManager.startUpdatingLocation()

            // Grab the fuel price for today upon starting. Maybe this should wait until it is certain they will save the entry. TBD.
            let onSuccess = {(fuelPrice: EiaWeeklyFuelPrice) -> Void in
                self.trip.fuelPrice = fuelPrice.price
                self.trip.fuelPriceDate = fuelPrice.startDate
                self.trip.fuelPriceSeriesId = fuelPrice.seriesId
            }
            let onError = {() -> Void in
                
            }
            CaFuelPriceFinder.instance.fuelPrice(forDate: trip.startTimestamp, onSuccess: onSuccess, onError: onError)
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
        mapView.showsUserLocation = false
        trip.endTimestamp = NSDate()
        performSegueWithIdentifier(CaSegue.TrackedProgressToSummary, sender: self)
    }
    
    // MARK: - Miscellaneous
    
    private func addTripWaypoint(location: CLLocation) {
        
        trip.waypoints.addObject(CaDataManager.instance.initWaypointWithLocation(lastLocation, trip: trip))
    }

    private func getActivityTypeAndAccuracyForMode() -> (activityType: CLActivityType, accuracy: CLLocationAccuracy) {
        
        if trip.modeType == Mode.Bicycle || trip.modeType == Mode.Walk {
            return (CLActivityType.Fitness, kCLLocationAccuracyNearestTenMeters)
        } else if trip.modeType == Mode.Bus || trip.modeType == Mode.Rideshare {
            return (CLActivityType.AutomotiveNavigation, kCLLocationAccuracyNearestTenMeters)
        } else if trip.modeType == Mode.Train {
            return (CLActivityType.OtherNavigation, kCLLocationAccuracyHundredMeters)
        }
        return (CLActivityType.Other, kCLLocationAccuracyKilometer)
    }
}
