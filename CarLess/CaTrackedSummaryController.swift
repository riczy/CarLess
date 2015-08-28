import UIKit

class CaTrackedSummaryController: UIViewController {
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    
    var trip: Trip?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        discardButton.addTarget(self, action: "discard", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // MARK: - Scene Actions
    
    func save() {
        
        performSegueWithIdentifier(CaSegue.TrackedSummaryToHome, sender: self)
    }
    
    func discard() {
        
        performSegueWithIdentifier(CaSegue.TrackedSummaryToHome, sender: self)
    }

}
