import UIKit

class CaTripRouteProgressView: UIView {
    
    @IBOutlet var view: CaTripRouteProgressView!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var durationValueLabel: UILabel!
    @IBOutlet weak var modeValueLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("CaTripRouteProgressView", owner: self, options: nil)
        self.addSubview(self.view)
    }
    
    func setLabelColor(color: UIColor) {
        
        distanceLabel.textColor = color
        durationLabel.textColor = color
        modeLabel.textColor = color
    }
    
    func setValueColor(color: UIColor) {
        
        distanceValueLabel.textColor = color
        durationValueLabel.textColor = color
        modeValueLabel.textColor = color
    }
}
