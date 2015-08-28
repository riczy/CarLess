import UIKit

class LogController: UIViewController {
    
    
    @IBOutlet weak var logModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var manualLogEntryView: UIView!
    @IBOutlet weak var trackedLogEntryView: UIView!
    
    private var trip = Trip()
    
    struct LogModeControl {
        static let TrackSegment = 0
        static let ManualSegment = 1
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        logModeSegmentedControl.addTarget(self, action: "logModeControlPressed", forControlEvents: UIControlEvents.ValueChanged)
        logModeSegmentedControl.setTitle("Track", forSegmentAtIndex: LogModeControl.TrackSegment)
        logModeSegmentedControl.setTitle("Manual", forSegmentAtIndex: LogModeControl.ManualSegment)
        
        logModeSegmentedControl.selectedSegmentIndex = LogModeControl.TrackSegment
        logModeControlPressed()
        
    }

    func logModeControlPressed() {
        
        if logModeSegmentedControl.selectedSegmentIndex == LogModeControl.TrackSegment {
            manualLogEntryView.hidden = true
            trackedLogEntryView.hidden = false
        } else if logModeSegmentedControl.selectedSegmentIndex == LogModeControl.ManualSegment {
            manualLogEntryView.hidden = false
            trackedLogEntryView.hidden = true
        }
    }
    
    @IBAction func backToLogMain() {
        // help
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
//        let segueId = segue.identifier!
//        let dvc: AnyObject = segue.destinationViewController
//        if segueId == Storyboard.TripDateSegue {
//            let dateVc = dvc.topViewController as! DateViewController
//            dateVc.initialDate = trip.date
//        } else if segueId == Storyboard.TripModeSegue {
//            let modesVc = dvc.topViewController as! CaModeListController
//            modesVc.mode = trip.mode
//        } else if segueId == Storyboard.TripRouteSegue {
//            let routeVc = dvc.topViewController as! ManualRouteController
//            routeVc.route = trip.route
//        }
    }

}
