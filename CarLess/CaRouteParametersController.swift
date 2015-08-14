
import UIKit

class CaRouteParametersController: UIViewController {
    
    @IBOutlet var routeParametersView: UIView!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var modeImage: UIImageView!
    @IBOutlet weak var modeNavigationLabel: UILabel!
    
    private var modeLabelTapRecognizer = UITapGestureRecognizer()
    private var modeNavigationTapRecognizer = UITapGestureRecognizer()
    
    var _mode: Mode?
    private var mode: Mode {
        get {
            if _mode == nil {
                _mode = Mode.allValues.first
                updateDisplayForMode(_mode!)
            }
            return _mode!
        }
        set {
            _mode = newValue
            updateDisplayForMode(_mode!)
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        routeParametersView.layer.borderColor = UIColor.lightGrayColor().CGColor
        routeParametersView.layer.borderWidth = 1.0
        
        modeLabelTapRecognizer.numberOfTapsRequired = 1
        modeLabelTapRecognizer.numberOfTouchesRequired = 1
        modeLabelTapRecognizer.addTarget(self, action: "handleModeTapGesture:")
        
        modeNavigationTapRecognizer.numberOfTapsRequired = 1
        modeNavigationTapRecognizer.numberOfTouchesRequired = 1
        modeNavigationTapRecognizer.addTarget(self, action: "handleModeTapGesture:")
        
        modeLabel.userInteractionEnabled = true
        modeLabel.adjustsFontSizeToFitWidth = true
        modeLabel.addGestureRecognizer(modeLabelTapRecognizer)
        
        modeNavigationLabel.userInteractionEnabled = true
        modeNavigationLabel.addGestureRecognizer(modeNavigationTapRecognizer)
        
        // Initialize mode
        mode = Mode.allValues.first!
    }

    func handleModeTapGesture(gesture: UITapGestureRecognizer) {
        
        performSegueWithIdentifier(CaSegue.MappedRouteToModeList, sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == CaSegue.MappedRouteToModeList {
            // It's a modal segue to the mode list vc; thus, get top vc
            let vc = segue.destinationViewController.topViewController as! CaModeListController
            vc.mode = mode
        }
    }
    
    
    @IBAction
    func cancel(segue: UIStoryboardSegue) {
        // do nothing
    }
    
    @IBAction
    func saveModeSelection(segue: UIStoryboardSegue) {
        
        let vc: CaModeListController = segue.sourceViewController as! CaModeListController
        mode = vc.mode!
        modeLabel.text = mode.description
    }
    
    private func updateDisplayForMode(mode: Mode) {
        
        modeLabel.text! = mode.description
        modeImage?.image = UIImage(named: mode.imageFilename)
    }
}
