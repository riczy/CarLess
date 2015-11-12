import Foundation
import UIKit

class CaLogTripSummaryController: UIViewController {
    
    // MARK: - UI Properties
    
    private var navigationBar: UINavigationBar!
    private var startTimestampLabel: UILabel!
    private var distanceLabel: UILabel!
    private var modeImageView: UIImageView!
    private var moneySavedLabel: UILabel!
    private var fuelSavedLabel: UILabel!
    private var distanceTitleLabel: UILabel!
    private var fuelSavedTitleLabel: UILabel!
    private var moneySavedTitleLabel: UILabel!
    private var spinnerView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    var trip: Trip?
    var isSaveableSummary = false
    var exitSegue: String?
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setComponents()
        setConstraints()
    }
    
    // MARK: - View Initializations
    
    private func setComponents() {
        
        let valueFont: UIFont = {
            let fontDescriptor = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
            return UIFont(descriptor: fontDescriptor, size: 0)
        }()
        let valueTitleFont: UIFont = {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        }()
        
        
        view.backgroundColor = CaStyle.ViewBgColor
        
        navigationBar = UINavigationBar()
        navigationBar.barTintColor = CaStyle.NavBarBgTintColor
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        
        startTimestampLabel = UILabel()
        startTimestampLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        startTimestampLabel.textAlignment = NSTextAlignment.Center
        startTimestampLabel.textColor = CaStyle.InstructionHeadlineColor
        startTimestampLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startTimestampLabel)
        
        modeImageView = UIImageView()
        modeImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeImageView)
        
        distanceLabel = UILabel()
        distanceLabel.font = valueFont
        distanceLabel.textAlignment = NSTextAlignment.Center
        distanceLabel.textColor = CaStyle.InputFieldColor
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distanceLabel)
        
        distanceTitleLabel = UILabel()
        distanceTitleLabel.font = valueTitleFont
        distanceTitleLabel.textAlignment = NSTextAlignment.Center
        distanceTitleLabel.textColor = CaStyle.InputLabelColor
        distanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distanceTitleLabel)
        
        fuelSavedLabel = UILabel()
        fuelSavedLabel.font = valueFont
        fuelSavedLabel.textAlignment = NSTextAlignment.Center
        fuelSavedLabel.textColor = CaStyle.InputFieldColor
        fuelSavedLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fuelSavedLabel)
        
        fuelSavedTitleLabel = UILabel()
        fuelSavedTitleLabel.font = valueTitleFont
        fuelSavedTitleLabel.textAlignment = NSTextAlignment.Center
        fuelSavedTitleLabel.textColor = CaStyle.InputLabelColor
        fuelSavedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fuelSavedTitleLabel)
        
        moneySavedLabel = UILabel()
        moneySavedLabel.font = valueFont
        moneySavedLabel.textAlignment = NSTextAlignment.Center
        moneySavedLabel.textColor = CaStyle.InputFieldColor
        moneySavedLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(moneySavedLabel)
        
        moneySavedTitleLabel = UILabel()
        moneySavedTitleLabel.font = valueTitleFont
        moneySavedTitleLabel.textAlignment = NSTextAlignment.Center
        moneySavedTitleLabel.textColor = CaStyle.InputLabelColor
        moneySavedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(moneySavedTitleLabel)
        
        spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        spinnerView.color = CaStyle.ActivitySpinnerColor
        spinnerView.center = view.center
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)
        
        setDisplayText()
        renderNavigationButtonItems()
    }
    
    private func setConstraints() {
        
        let valueWidth: CGFloat = view.frame.size.width / 3.0
        let valueTopMargin: CGFloat = 20
        let valueTitleTopMargin: CGFloat = 3
        
        view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 64))
        view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: navigationBar, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        
        view.addConstraint(NSLayoutConstraint(item: startTimestampLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: navigationBar, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: startTimestampLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: startTimestampLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: startTimestampLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40))
        view.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 40))
        
        view.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTopMargin))
        view.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        view.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: fuelSavedLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTopMargin))
        view.addConstraint(NSLayoutConstraint(item: fuelSavedLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        view.addConstraint(NSLayoutConstraint(item: fuelSavedLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: distanceLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: moneySavedLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTopMargin))
        view.addConstraint(NSLayoutConstraint(item: moneySavedLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        view.addConstraint(NSLayoutConstraint(item: moneySavedLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        
        view.addConstraint(NSLayoutConstraint(item: distanceTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: distanceLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTitleTopMargin))
        view.addConstraint(NSLayoutConstraint(item: distanceTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        view.addConstraint(NSLayoutConstraint(item: distanceTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTitleTopMargin))
        view.addConstraint(NSLayoutConstraint(item: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        view.addConstraint(NSLayoutConstraint(item: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: distanceTitleLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        view.addConstraint(NSLayoutConstraint(item: moneySavedTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: moneySavedLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTitleTopMargin))
        view.addConstraint(NSLayoutConstraint(item: moneySavedTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        view.addConstraint(NSLayoutConstraint(item: moneySavedTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
    }
    
    private func setDisplayText() {
        
        let distanceUnit = CaDataManager.instance.defaultDistanceUnit
        let distanceFormatter = NSNumberFormatter()
        distanceFormatter.minimumFractionDigits = 0
        distanceFormatter.maximumFractionDigits = 2
        distanceFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        distanceTitleLabel.text = "\(distanceUnit.rawValue.lowercaseString)s"
        fuelSavedTitleLabel.text = "fuel saved"
        moneySavedTitleLabel.text = "money saved"
        
        if trip == nil {
            distanceLabel.text = "--"
            fuelSavedLabel.text = "--"
            moneySavedLabel.text = "--"
            startTimestampLabel.text = "--"
        } else {
            distanceLabel.text = "\(distanceFormatter.stringFromNumber(trip!.getDistanceInUnit(distanceUnit))!)"
            if let fuelSaved = trip?.fuelSaved() {
                fuelSavedLabel.text = "\(CaFormatter.decimalDisplay.stringFromNumber(fuelSaved)!) gal"
            } else {
                fuelSavedLabel.text = "--"
            }
            modeImageView.image = UIImage(named: trip!.modeType.imageFilename)
            if let moneySaved = trip?.moneySaved() {
                moneySavedLabel.text = CaFormatter.money.stringFromNumber(moneySaved)
            } else {
                moneySavedLabel.text = "--"
            }
            startTimestampLabel.text = CaFormatter.timestamp.stringFromDate(trip!.startTimestamp)
        }
        
    }
    
    private func renderNavigationButtonItems() {
        
        let navigationItem = UINavigationItem()
        navigationItem.title = "Trip Summary"
    
        if isSaveableSummary {
            let trashButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "discard")
            let saveButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")
            navigationItem.leftBarButtonItem = trashButtonItem
            navigationItem.rightBarButtonItem = saveButtonItem
        } else {
            let doneButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "exit")
            navigationItem.leftBarButtonItem = doneButtonItem
        }
        navigationBar.items = [ navigationItem ]
    }
    
  
    // MARK: - Scene Actions
    
    func save() {
        
        if validate() {
            preSave()
            trip?.pending = false
            CaDataManager.instance.save(trip: trip!)
            postSave()
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
            self.exit()
        }
    }
    
    func discard() {
        
        let alert = UIAlertController(title: nil, message: "Remove this trip?", preferredStyle: UIAlertControllerStyle.Alert)
        let discardAction = UIAlertAction(title: "Yes, remove", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            CaDataManager.instance.rollback(self.trip!)
            self.exit()
        }
        let cancelAction = UIAlertAction(title: "No, continue", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in }
        alert.addAction(discardAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true) { () -> Void in }
    }
    
    func exit() {
    
        trip = nil
        performSegueWithIdentifier(self.exitSegue!, sender: self)
    }

}
