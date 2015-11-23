import MapKit
import UIKit

class CaTripSummaryController: UIViewController {
    
    var trip: Trip!
    var summaryView: CaTripSummaryView!

    override func viewDidLoad() {
        super.viewDidLoad()
        constructViews()
        setDisplayText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func constructViews() {

        let showMap = trip.waypoints.count > 0
        summaryView = CaTripSummaryView(showMap: showMap)
        if showMap {
            summaryView.mapView!.delegate = self
            summaryView.mapView!.region = tripRouteMapRegion()!
            summaryView.mapView!.addOverlay(tripRoutePolyline())
        }

        
        // TODO: How to account for nav bar, if any, in constraints?
        var navBarHeight: CGFloat = 0.0
        if let navbar = navigationController?.navigationBar {
            navBarHeight = navbar.frame.height
        }
        
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(summaryView)
        view.addConstraint(NSLayoutConstraint(item: summaryView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: navBarHeight + 4))
        view.addConstraint(NSLayoutConstraint(item: summaryView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: summaryView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: summaryView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
    }
    
    private func setDisplayText() {
        
        let distanceUnit = CaDataManager.instance.defaultDistanceUnit
        let distanceFormatter = NSNumberFormatter()
        distanceFormatter.minimumFractionDigits = 0
        distanceFormatter.maximumFractionDigits = 2
        distanceFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        summaryView.startTimestampLabel.text = CaFormatter.timestamp.stringFromDate(trip!.startTimestamp)
        summaryView.co2SavedLabel.text = trip.co2Saved() == nil ? "--" : "\(distanceFormatter.stringFromNumber(trip.co2Saved()!)!) lb"
        summaryView.fuelSavedLabel.text = trip.fuelSaved() == nil ? "--" : "\(CaFormatter.decimalDisplay.stringFromNumber(trip.fuelSaved()!)!) gal"
        summaryView.moneySavedLabel.text = trip.moneySaved() == nil ? "--" : CaFormatter.money.stringFromNumber(trip.moneySaved()!)
        summaryView.distanceLabel.text = "\(distanceFormatter.stringFromNumber(trip!.getDistanceInUnit(distanceUnit))!) \(distanceUnit.abbreviation)"
        summaryView.modeLabel.text = "\(trip.modeType.rawValue)"
    
    }
    
    // MARK: - Map Rendering
    
    // Return the region that encompasses the trip's route. If the trip does not
    // have waypoints associated with it then no region is returned.
    //
    private func tripRouteMapRegion() -> MKCoordinateRegion? {
        
        let waypoints = trip.waypoints.allObjects as! [Waypoint]
        if waypoints.count == 0 {
            return nil
        }
        
        var minLat = waypoints[0].latitude.doubleValue
        var maxLat = waypoints[0].latitude.doubleValue
        var minLong = waypoints[0].longitude.doubleValue
        var maxLong = waypoints[0].longitude.doubleValue
        
        if waypoints.count > 1 {
            for index in 1...(waypoints.count - 1) {
                minLat = min(minLat, waypoints[index].latitude.doubleValue)
                maxLat = max(maxLat, waypoints[index].latitude.doubleValue)
                minLong = min(minLong, waypoints[index].longitude.doubleValue)
                maxLong = max(maxLong, waypoints[index].longitude.doubleValue)
            }
        }
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLong + maxLong)/2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.5, longitudeDelta: (maxLong - minLong)*1.5)
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
    // Return the polyline of waypoints that trace the trip's route.
    //
    private func tripRoutePolyline() -> MKPolyline {
        
        var coordinates = [CLLocationCoordinate2D]()
        let sortOrder = NSSortDescriptor(key: "timestamp", ascending: true)
        
        if  let waypoints = trip?.waypoints.sortedArrayUsingDescriptors([sortOrder]) as? [Waypoint] {
            for waypoint in waypoints {
                coordinates.append(waypoint.coordinate)
            }
        }
        return MKPolyline(coordinates: &coordinates, count: coordinates.count)
    }
}

extension CaTripSummaryController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        // Only expecting a polyline overlay therefore skip checking of overlay
        // type.
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = CaStyle.MapRouteLineColor
        renderer.lineWidth = CaStyle.MapRouteLineWidth
        return renderer
    }
}
