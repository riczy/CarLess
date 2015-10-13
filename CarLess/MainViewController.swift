import UIKit

class MainViewController: UITabBarController {
    
    @IBInspectable
    var defaultIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
        
        tabBar.barTintColor = CaStyle.TabBarBgTintColor
        tabBar.tintColor = CaStyle.TabBarTintColor
    }

}
