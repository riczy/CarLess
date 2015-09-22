import Foundation
import UIKit

class CaTrackedSummaryController: UIViewController {
    
    // MARK: - UI Properties
    
    @IBOutlet weak var activityHeadingLabel: UILabel!
    @IBOutlet weak var startTimestampLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    private var spinnerView: UIActivityIndicatorView!
    private var saveButton: UIButton!
    private var discardButton: UIButton!
    
    // MARK: - Properties
    
    var trip: Trip?
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeSpinner()
        renderSaveButton()
        renderDiscardButton()
        initializeStyle()
        setDisplayText()
    }
    
    // MARK: - View Initializations
    
    private func setDisplayText() {
        
        if trip != nil {
            let distanceUnit = CaDataManager.instance.getDistanceUnitDisplaySetting()
            distanceLabel.text = "\(CaFormatter.distance.stringFromNumber(trip!.getDistanceInUnit(distanceUnit)!)!) \(distanceUnit.abbreviation)"
            startTimestampLabel.text = CaFormatter.timestamp.stringFromDate(trip!.startTimestamp)
            modeLabel.text = trip!.modeType.description
        }
    }
    
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
    
    private func renderSaveButton() {
        
        saveButton = CaComponent.createButton(title: "Save", color: CaLogStyle.SaveButtonColor, bgColor: CaLogStyle.SaveButtonBgColor, borderColor: CaLogStyle.SaveButtonBorderColor)
        self.view.addSubview(saveButton)
        
        
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: -5.0))
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: -20.0))
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonWidth))
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonHeight))
        
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    
    private func renderDiscardButton() {
        
        discardButton = CaComponent.createButton(title: "Discard", color: CaLogStyle.DiscardButtonColor, bgColor: CaLogStyle.DiscardButtonBgColor, borderColor: CaLogStyle.DiscardButtonBorderColor)
        self.view.addSubview(discardButton)
        
        
        view.addConstraint(NSLayoutConstraint(item: discardButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 5.0))
        view.addConstraint(NSLayoutConstraint(item: discardButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: -20.0))
        view.addConstraint(NSLayoutConstraint(item: discardButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonWidth))
        view.addConstraint(NSLayoutConstraint(item: discardButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonHeight))
        
        discardButton.addTarget(self, action: "discard", forControlEvents: UIControlEvents.TouchUpInside)
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
        }
    }
    
    func discard() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to discard this trip?", preferredStyle: UIAlertControllerStyle.Alert)
        let discardAction = UIAlertAction(title: "Yes, discard", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.exit()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in }
        alert.addAction(discardAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true) { () -> Void in }
    }
    
    private func exit() {
    
        trip = nil
        performSegueWithIdentifier(CaSegue.TrackedSummaryToHome, sender: self)
    }

}
