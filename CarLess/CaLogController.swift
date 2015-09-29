import UIKit

class CaLogController: UIViewController {
    
    
    @IBOutlet weak var logModeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var manualLogEntryView: UIView!
    @IBOutlet weak var trackedLogEntryView: UIView!
    
    struct LogModeControl {
        static let TrackSegment = 0
        static let ManualSegment = 1
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeStyle()
        initializeLogModeSegmentControl()
        logModeControlPressed()
    }
    
    private func initializeStyle() {
        
        let navController = self.navigationController
        navController?.navigationBar.barTintColor = CaLogStyle.SegmentBarBgColor
        view.backgroundColor = CaLogStyle.ViewBgColor
    }
    
    private func initializeLogModeSegmentControl() {
        
        logModeSegmentedControl.setTitle("Track", forSegmentAtIndex: LogModeControl.TrackSegment)
        logModeSegmentedControl.setTitle("Manual", forSegmentAtIndex: LogModeControl.ManualSegment)
        logModeSegmentedControl.tintColor = CaLogStyle.SegmentControlColor
        
        logModeSegmentedControl.addTarget(self, action: "logModeControlPressed", forControlEvents: UIControlEvents.ValueChanged)

        logModeSegmentedControl.selectedSegmentIndex = LogModeControl.TrackSegment
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
    
}
