import UIKit

class DisplayBoxView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("DisplayBoxView", owner: self, options: nil)
        self.addSubview(self.view)
    }
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        NSBundle.mainBundle().loadNibNamed("DisplayBoxView", owner: self, options: nil)
        self.frame = frame
        self.addSubview(self.view)
    }
}
