import UIKit

/// The view controller for displaying the trip summary after the user finished
/// tracking a trip.
///
class LogTrackedTripSummaryController: CaTripSummaryController {

    private var spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    override func constructViews() {
        
        let navigationItem = UINavigationItem()
        navigationItem.title = "Trip Summary"
        
        let trashButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Trash, target: self, action: "discard")
        let saveButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "save")
        navigationItem.leftBarButtonItem = trashButtonItem
        navigationItem.rightBarButtonItem = saveButtonItem
        
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 64))
        navigationBar!.barTintColor = CaStyle.NavBarBgTintColor
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        navigationBar!.items = [ navigationItem ]
        
        view.addSubview(navigationBar!)
        view.addConstraint(NSLayoutConstraint(item: navigationBar!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: navigationBar!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 64))
        view.addConstraint(NSLayoutConstraint(item: navigationBar!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: navigationBar!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        super.constructViews()
        
        spinnerView.color = CaStyle.ActivitySpinnerColor
        spinnerView.center = view.center
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)
    }

    // MARK: - Scene Actions
    
    func save() {
        
        preSave()
        trip.pending = false
        CaDataManager.instance.save(trip: trip!)
        postSave()
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
        performSegueWithIdentifier(CaSegue.LogTrackedTripSummaryToHome, sender: self)
    }
}
