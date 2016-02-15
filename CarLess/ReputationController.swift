import UIKit

class ReputationController: UIViewController {
    
    var repView: ReputationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        constructView()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        repView.points = CaDataManager.instance.fetchReputation()
        repView.weekAgoPoints = CaDataManager.instance.fetchWeekAgoReputation()
    }
    
    func constructView() {
        
        repView = ReputationView()
        repView.translatesAutoresizingMaskIntoConstraints = false
        
        navigationController?.navigationBar.barTintColor = CaStyle.NavBarBgTintColor
        navigationController?.navigationBar.tintColor = CaStyle.NavBarTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CaStyle.NavBarTitleColor]
        
        view.addSubview(repView)
        view.addConstraint(NSLayoutConstraint(item: repView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: repView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: repView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: repView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
    }
}
