import UIKit

class CaMappedRouteSummaryController: UIViewController {
    
    @IBOutlet weak var summaryView: CaTripRouteProgressView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        discardButton.addTarget(self, action: "discard", forControlEvents: UIControlEvents.TouchUpInside)
        
        summaryView.setLabelColor(UIColor.whiteColor())
        summaryView.setValueColor(UIColor.whiteColor())
    }
    
    func save() {
        
        performSegueWithIdentifier(CaSegue.MappedRouteSummaryToMain, sender: self)
    }
    
    func discard() {
        
        performSegueWithIdentifier(CaSegue.MappedRouteSummaryToMain, sender: self)
    }
    

}
