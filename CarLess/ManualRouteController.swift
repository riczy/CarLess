import UIKit

class ManualRouteController: UIViewController, UITextFieldDelegate {
    
    private struct Constants {
        
        static let RouteNameFieldTag = 100
        static let DistanceFieldTag = 101
    }

    var route: ManualRoute = ManualRoute()
    
    @IBOutlet weak var routeNameField: UITextField!
    @IBOutlet weak var distanceField: UITextField!
    @IBOutlet weak var distanceUnitLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        routeNameField.tag = Constants.RouteNameFieldTag
        distanceField.tag = Constants.DistanceFieldTag
        
        routeNameField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
        distanceField.addTarget(self, action: "textFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
        distanceField.delegate = self
        
        distanceUnitLabel.text = route.distanceUnit.abbreviation
        if route.routeName != nil {
            routeNameField.text = route.routeName!
        }        
        if route.distance != nil {
            distanceField.text = "\(route.distance!)"
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == Constants.DistanceFieldTag {
            return ManualRoute.formatter.numberFromString("\(textField.text)\(string)") != nil
        }
        return true
    }
    
    func textFieldChanged(textField: UITextField) {
        
        if textField.tag == Constants.RouteNameFieldTag {
            route.routeName = textField.text
        } else if textField.tag == Constants.DistanceFieldTag {
            if let newValue = ManualRoute.formatter.numberFromString(textField.text) {
                route.distance = newValue.doubleValue
            }
        }
    }
    
}
