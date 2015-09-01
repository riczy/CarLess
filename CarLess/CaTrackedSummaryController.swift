import Foundation
import UIKit

class CaTrackedSummaryController: UIViewController {
    
    // MARK: - UI Properties
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var activityHeadingLabel: UILabel!
    @IBOutlet weak var startTimestampLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    private var spinnerView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var trip: Trip?
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeSpinner()
        initializeStyle()
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        discardButton.addTarget(self, action: "discard", forControlEvents: UIControlEvents.TouchUpInside)
        
        if trip != nil {
            
            startTimestampLabel.text = CaFormatter.timestamp.stringFromDate(trip!.startTimestamp!)
            distanceLabel.text = "\(CaFormatter.distance.stringFromNumber(trip!.distance!)!) \(trip!.distanceUnit!.abbreviation)"
            modeLabel.text = trip?.mode?.description
        }
    }
    
    // MARK: - View Initializations
    
    private func initializeStyle() {
        
        view.backgroundColor = CaLogStyle.ViewBgColor
        activityHeadingLabel.textColor = CaLogStyle.ViewLabelColor
        startTimestampLabel.textColor = CaLogStyle.ViewFieldColor
        distanceLabel.textColor = CaLogStyle.ViewFieldColor
        modeLabel.textColor = CaLogStyle.ViewFieldColor
        spinnerView.color = CaLogStyle.ActivitySpinnerColor
    }
    
    private func initializeSpinner() {
        
        spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        spinnerView.color = UIColor.purpleColor()
        spinnerView.center = view.center
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)
    }
  
    // MARK: - Scene Actions
    
    func save() {
        
        if validate() {
            preSave()
            CaDataManager.instance.saveTrip(trip!)
            postSave()
        }
    }
    
    private func validate() -> Bool {
        
        if trip == nil {
            return false
        }
        return true
    }
    
    private func preSave() {
        
        view.alpha = CaConstants.SaveDisplayAlpha
        saveButton.enabled = false
        discardButton.enabled = false
        spinnerView.startAnimating()
    }
    
    private func postSave() {
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(CaConstants.SaveActivityDelay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.spinnerView.stopAnimating()
            self.saveButton.enabled = true
            self.discardButton.enabled = true
            self.view.alpha = 1.0
            self.performSegueWithIdentifier(CaSegue.TrackedSummaryToHome, sender: self)
        }
    }
    
    func discard() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to discard this trip?", preferredStyle: UIAlertControllerStyle.Alert)
        let discardAction = UIAlertAction(title: "Yes, discard", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.performSegueWithIdentifier(CaSegue.TrackedSummaryToHome, sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in }
        alert.addAction(discardAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true) { () -> Void in }
    }

}
