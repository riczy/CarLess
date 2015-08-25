import UIKit
import MapKit

class CaMappedRouteController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var modeImage: UIImageView!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var modeNavigationLabel: UILabel!

    private var modeLabelTapRecognizer = UITapGestureRecognizer()
    private var modeNavigationTapRecognizer = UITapGestureRecognizer()

    private var _mode: Mode?
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
    

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if identifier == CaSegue.MappedRouteToInProgress {
            if CaLocationManager.isLocationServiceAvailable() {
                return true
            } else {
                CaLocationManager.instance.requestAlwaysAuthorization()
                return false
            }
        }
        return true
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == CaSegue.MappedRouteToInProgress {
            let vc = segue.destinationViewController as! CaMappedRouteProgressController
            vc.mode = mode
        } else if segue.identifier == CaSegue.MappedRouteToModeList {
            // It's a modal segue to the mode list vc; thus, get top vc
            let vc = segue.destinationViewController.topViewController as! CaModeListController
            vc.mode = mode
        }
    }
    
    @IBAction
    func cancelMappedRouteModeSelection(segue: UIStoryboardSegue) {
        // do nothing
    }
    
    @IBAction
    func saveMappedRouteModeSelection(segue: UIStoryboardSegue) {
        
        let vc: CaModeListController = segue.sourceViewController as! CaModeListController
        mode = vc.mode!
    }
    
    @IBAction
    func unwindToTripTrackingBeginning(segue: UIStoryboardSegue) {
    }
    
    private func updateDisplayForMode(mode: Mode) {
        
        modeLabel.text! = mode.description
        modeImage?.image = UIImage(named: mode.imageFilename)
    }
    
}
