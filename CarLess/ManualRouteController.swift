import UIKit

class ManualRouteController: UIViewController, UITextFieldDelegate {
    
    private struct Constants {
        
        static let StartLocationFieldTag = 100
        static let EndLocationFieldTag = 101
        static let DistanceFieldTag = 102
    }

    var route: ManualRoute = ManualRoute()
    
    private var formatter: NSNumberFormatter!
    
    @IBOutlet weak var startLocationField: UITextField!
    @IBOutlet weak var endLocationField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var distanceStepper: UIStepper!
    
    @IBAction func stepDistance(sender: UIStepper) {
    }
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.minimum = 0
   }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        distanceStepper.minimumValue = 1
        distanceStepper.maximumValue = 100
        
        startLocationField.tag = Constants.StartLocationFieldTag
        endLocationField.tag = Constants.EndLocationFieldTag
        distanceField.tag = Constants.DistanceFieldTag
        
        startLocationField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingDidEnd)
        endLocationField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingDidEnd)
        distanceField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingDidEnd)
        distanceField.delegate = self
        
        if route.startLocation != nil {
            startLocationField.text = route.startLocation!
        }
        
        if route.endLocation != nil {
            endLocationField.text = route.endLocation!
        }
        
        if route.distance != nil {
            distanceField.text = "\(route.distance!)"
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == Constants.DistanceFieldTag {
            return formatter.numberFromString("\(textField.text)\(string)") != nil
        }
        return true
    }
    
    func textFieldChanged(textField: UITextField) {
        
        if textField.tag == Constants.StartLocationFieldTag {
            route.startLocation = textField.text
        } else if textField.tag == Constants.EndLocationFieldTag {
            route.endLocation = textField.text
        } else if textField.tag == Constants.DistanceFieldTag {
            if let newValue = formatter.numberFromString(textField.text) {
                route.distance = newValue.doubleValue
            }
        }
    }
    
}
