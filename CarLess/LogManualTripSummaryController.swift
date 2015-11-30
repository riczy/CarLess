import UIKit

/// The view controller for displaying the trip summary after the user entered a
/// trip manually.
///
class LogManualTripSummaryController: CaTripSummaryController {
    
    override func constructViews() {
        
        let navigationItem = UINavigationItem()
        navigationItem.title = "Trip Summary"
        
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "exit")
        navigationItem.leftBarButtonItem = doneButtonItem
        
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 64))
        navigationBar!.barTintColor = CaStyle.NavBarBgTintColor
        navigationBar!.tintColor = CaStyle.NavBarTintColor
        navigationBar!.titleTextAttributes = [NSForegroundColorAttributeName: CaStyle.NavBarTitleColor]
        navigationBar!.translatesAutoresizingMaskIntoConstraints = false
        navigationBar!.items = [ navigationItem ]
        
        view.addSubview(navigationBar!)
        view.addConstraint(NSLayoutConstraint(item: navigationBar!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.TopMargin, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: navigationBar!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 64))
        view.addConstraint(NSLayoutConstraint(item: navigationBar!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: navigationBar!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        super.constructViews()
    }
    
    func exit() {
        
        trip = nil
        performSegueWithIdentifier(CaSegue.LogManualTripSummaryToHome, sender: self)
    }

}
