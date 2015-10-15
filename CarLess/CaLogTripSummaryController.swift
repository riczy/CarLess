import Foundation
import UIKit

class CaLogTripSummaryController: UIViewController {
    
    // MARK: - UI Properties
    
    @IBOutlet weak var startTimestampLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var moneySavedLabel: UILabel!
    @IBOutlet weak var fuelSavedLabel: UILabel!
    private var spinnerView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var trip: Trip?
    var isSaveableSummary = false
    var exitSegue: String?
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeSpinner()
        renderNavigationButtonItems()
        initializeStyle()
        setDisplayText()
    }
    
    // MARK: - View Initializations
    
    private func setDisplayText() {
        
        if trip == nil {
            distanceLabel.text = nil
            startTimestampLabel.text = nil
        } else {
            let distanceUnit = CaDataManager.instance.defaultDistanceUnit
            distanceLabel.text = "\(CaFormatter.decimalDisplay.stringFromNumber(trip!.getDistanceInUnit(distanceUnit))!) \(distanceUnit.abbreviation)"
            startTimestampLabel.text = CaFormatter.timestamp.stringFromDate(trip!.startTimestamp)
        }
        modeLabel.text = trip?.modeType.description
        if let moneySaved = trip?.moneySaved() {
            moneySavedLabel.text = CaFormatter.money.stringFromNumber(moneySaved)
        } else {
            moneySavedLabel.text = nil
        }
        if let fuelSaved = trip?.fuelSaved() {
            fuelSavedLabel.text = "\(CaFormatter.decimalDisplay.stringFromNumber(fuelSaved)!) gal"
        } else {
            fuelSavedLabel.text = nil
        }
    }
    
    private func initializeStyle() {
        
        view.backgroundColor = CaLogStyle.ViewBgColor
        startTimestampLabel.textColor = CaLogStyle.ViewFieldColor
        distanceLabel.textColor = CaLogStyle.ViewFieldColor
        modeLabel.textColor = CaLogStyle.ViewFieldColor
        spinnerView.color = CaStyle.ActivitySpinnerColor
    }
    
    private func initializeSpinner() {
        
        spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        spinnerView.color = UIColor.purpleColor()
        spinnerView.center = view.center
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)
    }
    
    private func renderNavigationButtonItems() {
    
        if isSaveableSummary {
            let trashButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "discard")
            let saveButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")
            navigationItem.leftBarButtonItem = trashButtonItem
            navigationItem.rightBarButtonItem = saveButtonItem
        } else {
            let doneButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "exit")
            navigationItem.leftBarButtonItem = doneButtonItem
        }
    }
    
  
    // MARK: - Scene Actions
    
    func save() {
        
        if validate() {
            preSave()
            CaDataManager.instance.save(trip: trip!)
            postSave()
            exit()
        }
    }
    
    private func validate() -> Bool {
        
        return trip !== nil
    }
    
    private func preSave() {
        
        view.alpha = CaConstants.SaveDisplayAlpha
        spinnerView.startAnimating()
    }
    
    private func postSave() {
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(CaConstants.SaveActivityDelay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.spinnerView.stopAnimating()
            self.view.alpha = 1.0
        }
    }
    
    func discard() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to discard this trip?", preferredStyle: UIAlertControllerStyle.Alert)
        let discardAction = UIAlertAction(title: "Yes, discard", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            CaDataManager.instance.rollback(self.trip!)
            self.exit()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in }
        alert.addAction(discardAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true) { () -> Void in }
    }
    
    func exit() {
    
        trip = nil
        performSegueWithIdentifier(self.exitSegue!, sender: self)
    }

}
