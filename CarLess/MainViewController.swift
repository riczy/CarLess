import UIKit

class MainViewController: UITabBarController {
    
    @IBInspectable
    var defaultIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }

    /*
     * This override is needed to get the unwind segues to properly work.
     * See http://stackoverflow.com/questions/25654941/unwind-segue-not-working-in-ios-8
     */
    override func viewControllerForUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject?) -> UIViewController? {
        
        var resultVC = self.selectedViewController?.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
        return resultVC
    }
}
