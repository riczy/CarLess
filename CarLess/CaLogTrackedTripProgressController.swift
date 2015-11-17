import UIKit
import CoreLocation
import MapKit

class CaLogTrackedTripProgressController: UIViewController {
    
    // MARK: - UI Properties

    private var mapView: MKMapView!
    private var distanceTitleLabel: UILabel!
    private var distanceValueLabel: UILabel!
    private var stopButton: UIButton!
    private var mapCenterButton: UIButton!
    
    // MARK: - Properties
    
    var mode: Mode!
    private var trip: Trip!
    private var waypoints: [Waypoint]!
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
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = true
        manager.requestAlwaysAuthorization()
        return manager
    }()
    private var useDefaultMapViewSpan = true
    private var centerUserCurrentLocation = true
    
    
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
    
    
    // MARK: - Scene Actions

    private func startTracking() {
        
        if CaLocationManager.isLocationServiceAvailable() {
            
            mapView.showsUserLocation = true
            
            waypoints = [Waypoint]()
            
            trip = CaDataManager.instance.initTrip()
            trip.distance = 0.0
            trip.endTimestamp = nil
            trip.logType = LogType.Tracked
            trip.modeType = mode
            trip.startTimestamp = NSDate()
            trip.vehicle = CaDataManager.instance.defaultVehicle
            trip.pending = true
            CaDataManager.instance.save()
            
            lastLocation = nil
            nextToLastLocation = nil
            
            setLocationFiltersByMode()
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
        
        let alert = UIAlertController(title: nil, message: "Stop tracking?", preferredStyle: UIAlertControllerStyle.Alert)
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
        trip.endTimestamp = NSDate()
        CaDataManager.instance.save()
        mapView.showsUserLocation = false
        performSegueWithIdentifier(CaSegue.LogTrackedTripProgressToSummary, sender: self)
    }
    
    // MARK: - Miscellaneous
    
    private func setLocationFiltersByMode() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if trip.modeType == Mode.Bicycle {
            locationManager.activityType = CLActivityType.Fitness
            locationManager.distanceFilter = 5.0
        } else if trip.modeType == Mode.Walk {
            locationManager.activityType = CLActivityType.Fitness
            locationManager.distanceFilter = 5.0
        } else if trip.modeType == Mode.Bus || trip.modeType == Mode.Rideshare {
            locationManager.activityType = CLActivityType.AutomotiveNavigation
            locationManager.distanceFilter = 20.0
        } else if trip.modeType == Mode.Train {
            locationManager.activityType = CLActivityType.OtherNavigation
            locationManager.distanceFilter = 30.0
        }
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
        mapView.showsCompass = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.zoomEnabled = true
        view.addSubview(mapView)

        stopButton = CaComponent.createButton(title: "Stop", color: CaStyle.LogStopButtonColor, bgColor: CaStyle.LogStopButtonBgColor, borderColor: CaStyle.LogStopButtonBorderColor)
        stopButton.addTarget(self, action: "signalStopTracking", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(stopButton)
        
        // The mapCenterButton is added directly to the mapView. No autoconstraints
        // are used and, instead, the frame dictates its location. Remember to set
        // mapCenterButton.translatesAutoresizingMaskIntoConstraints = false if you
        // use auto constraints.
        mapCenterButton = UIButton(type: .Custom)
        mapCenterButton.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.75)
        mapCenterButton.setImage(UIImage(named: "map-center"), forState: .Normal)
        mapCenterButton.frame = CGRect(x: 4, y: 6, width: 36, height: 36)
        mapCenterButton.layer.cornerRadius = 18
        mapCenterButton.addTarget(self, action: "centerUserLocationOnMap", forControlEvents: .TouchUpInside)
        self.mapView.addSubview(mapCenterButton)
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

/*
 * The extension handling for the Map View delegate.
 *
 */
extension CaLogTrackedTripProgressController: MKMapViewDelegate {
    
    func centerUserLocationOnMap() {
        centerUserCurrentLocation = true
        mapView(mapView, didUpdateUserLocation:  mapView.userLocation)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        if centerUserCurrentLocation {
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: (useDefaultMapViewSpan ? MKCoordinateSpanMake(0.009, 0.009) : mapView.region.span))
            mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        // There is only one overlay on this map therefore no checking of
        // overlay done.
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        polylineRenderer.strokeColor = CaStyle.MapRouteLineColor
        polylineRenderer.lineWidth = CaStyle.MapRouteLineWidth
        return polylineRenderer
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        if mapViewRegionDidChangeFromUserInteraction() {
            centerUserCurrentLocation = false
        }
    }
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        
        let view = self.mapView.subviews[0]
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if recognizer.state == UIGestureRecognizerState.Began || recognizer.state == UIGestureRecognizerState.Ended {
                    return true
                }
            }
        }
        return false
    }
}

/*
 * The extension handling for the Location Manager delegate.
 *
 */
extension CaLogTrackedTripProgressController: CLLocationManagerDelegate {
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let now = NSDate()
        
        for location in locations {
            let timeInterval = abs(location.timestamp.timeIntervalSinceDate(now))
            if location.horizontalAccuracy < 20 && timeInterval < 15 {
                
                if lastLocation == nil {
                    lastLocation = location
                    addTripWaypoint(location, discard: false, receivedTimestamp: now)
                } else {
                    let newestDistanceTraveled = lastLocation.distanceFromLocation(location)
                    if newestDistanceTraveled > 0 {
                        distanceTraveled += newestDistanceTraveled
                        nextToLastLocation = lastLocation
                        lastLocation = location
                        addTripWaypoint(location, discard: false, receivedTimestamp: now)
                        
                        var stepCoordinates = [lastLocation.coordinate, nextToLastLocation.coordinate]
                        mapView.addOverlay(MKPolyline(coordinates: &stepCoordinates, count: stepCoordinates.count))
                    }
                }
            } else {
                addTripWaypoint(location, discard: true, receivedTimestamp: now)
            }
            //NSLog("Location = \(dateFormatter.stringFromDate(location.timestamp)), Now = \(dateFormatter.stringFromDate(now)), Horiz = \(location.horizontalAccuracy), Interval = \(timeInterval), Discard = \(discard)")

        }
    }
    
    private func addTripWaypoint(location: CLLocation, discard: Bool, receivedTimestamp: NSDate) {
        
        let waypoint = CaDataManager.instance.initWaypointWithLocation(location, trip: trip)
        waypoint.discard = discard
        waypoint.receivedTimestamp = receivedTimestamp
        waypoints.append(waypoint)
        if waypoints.count == 100 {
            CaDataManager.instance.save()
            waypoints.removeAll(keepCapacity: true)
        }
    }
    
}
