import UIKit

class CaTrackedSummaryController: UIViewController {
    
    // MARK: - UI Property Outlets
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var discardButton: UIButton!
    
    @IBOutlet weak var startTimestampLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var modeLabel: UILabel!
    
    // MARK: - Properties
    
    var trip: Trip?
    
    // MARK: - View Lifecycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        discardButton.addTarget(self, action: "discard", forControlEvents: UIControlEvents.TouchUpInside)
        
        if trip != nil {
            
            startTimestampLabel.text = CaFormatter.timestamp.stringFromDate(trip!.startTimestamp!)
            distanceLabel.text = "\(CaFormatter.distance.stringFromNumber(trip!.distance!)!) \(trip!.distanceUnit!.abbreviation)"
            modeLabel.text = trip?.mode?.description
        }
    }
    
    // MARK: - Scene Actions
    
    func save() {
        
        if validate() {
            CaDataManager.instance.saveTrip(trip!)
            performSegueWithIdentifier(CaSegue.TrackedSummaryToHome, sender: self)
        }
    }
    
    func discard() {
        
        performSegueWithIdentifier(CaSegue.TrackedSummaryToHome, sender: self)
    }
    
    // MARK: - Miscellaneous Methods
    
    private func validate() -> Bool {
        
        if trip == nil {
            return false
        }
        return true
    }

}
