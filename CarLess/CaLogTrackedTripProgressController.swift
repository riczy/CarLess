import UIKit
import CoreLocation
import MapKit

class CaLogTrackedTripProgressController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - UI Properties

    private var mapView: MKMapView!
    private var distanceTitleLabel: UILabel!
    private var distanceValueLabel: UILabel!
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
            distanceValueLabel.text = CaFormatter.decimalDisplay.stringFromNumber(trip.getDistanceInUnit(CaDataManager.instance.defaultDistanceUnit))
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
        setComponents()
        setConstraints()
        startTracking()
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == CaSegue.LogTrackedTripProgressToSummary {
            let vc = segue.destinationViewController as! CaLogTripSummaryController
            vc.trip = trip
            vc.isSaveableSummary = true
            vc.exitSegue = CaSegue.LogTrackedTripSummaryToHome
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
        polylineRenderer.strokeColor = CaStyle.MapRouteLineColor
        polylineRenderer.lineWidth = CaStyle.MapRouteLineWidth
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
                NSLog("long=\(lastLocation.coordinate.longitude), lat=\(lastLocation.coordinate.latitude), step dist = \(newestDistanceTraveled), total dist = \(distanceTraveled)")
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
        
        let alert = UIAlertController(title: nil, message: "Stop this trip's mapping?", preferredStyle: UIAlertControllerStyle.Alert)
        let stopAction = UIAlertAction(title: "Yes, I'm finished", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                self.stopTracking()
        }
        let continueAction = UIAlertAction(title: "No, continue", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in }
        alert.addAction(stopAction)
        alert.addAction(continueAction)
        presentViewController(alert, animated: true) { () -> Void in }
    }
    
    private func stopTracking() {
        
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = false
        trip.endTimestamp = NSDate()
        performSegueWithIdentifier(CaSegue.LogTrackedTripProgressToSummary, sender: self)
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
    
    // MARK: - View Components
    
    private func setComponents() {
        
        view.backgroundColor = CaStyle.LogProgressViewBgColor

        distanceTitleLabel = UILabel()
        distanceTitleLabel.font = CaStyle.InputLabelFont
        distanceTitleLabel.text = "Distance"
        distanceTitleLabel.textAlignment = NSTextAlignment.Center
        distanceTitleLabel.textColor = CaStyle.LogDistanceLabelColor
        distanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distanceTitleLabel)
        
        distanceValueLabel = UILabel()
        distanceValueLabel.font = CaStyle.LogDistanceDisplayFont
        distanceValueLabel.text = "0.00"
        distanceValueLabel.textAlignment = NSTextAlignment.Center
        distanceValueLabel.textColor = CaStyle.LogDistanceDisplayColor
        distanceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distanceValueLabel)

        mapView = MKMapView()
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        mapView.pitchEnabled = false
        mapView.rotateEnabled = true
        mapView.scrollEnabled = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.zoomEnabled = true
        view.addSubview(mapView)

        stopButton = CaComponent.createButton(title: "Stop", color: CaStyle.LogStopButtonColor, bgColor: CaStyle.LogStopButtonBgColor, borderColor: CaStyle.LogStopButtonBorderColor)
        stopButton.addTarget(self, action: "signalStopTracking", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(stopButton)
    }
    
    private func setConstraints() {
        
        let hrView1 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CaStyle.InputFieldHrThickness))
        hrView1.backgroundColor = CaStyle.LogProgressViewHrColor
        hrView1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hrView1)

        
        view.addConstraint(NSLayoutConstraint(item: distanceTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 25))
        view.addConstraint(NSLayoutConstraint(item: distanceTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: distanceTitleLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: distanceValueLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: distanceTitleLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 3.0))
        view.addConstraint(NSLayoutConstraint(item: distanceValueLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: distanceValueLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

        view.addConstraint(NSLayoutConstraint(item: hrView1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: distanceValueLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 9))
        view.addConstraint(NSLayoutConstraint(item: hrView1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.InputFieldHrThickness))
        view.addConstraint(NSLayoutConstraint(item: hrView1, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: hrView1, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: hrView1, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: mapView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))

        view.addConstraint(NSLayoutConstraint(item: stopButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: stopButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: -30.0))
        view.addConstraint(NSLayoutConstraint(item: stopButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonWidth))
        view.addConstraint(NSLayoutConstraint(item: stopButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonHeight))
    }
    
}
