import UIKit

class ManualRouteController: UIViewController, UITextFieldDelegate {

    private var formatter: NSNumberFormatter!
    
    @IBOutlet weak var startLocationField: UITextField!
    
    @IBOutlet weak var endLocationField: UITextField!
    
    @IBOutlet weak var distanceField: UITextField!
    
    @IBAction func stepDistance(sender: UIStepper) {
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        distanceField.delegate = self
        
        formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.minimum = 0.1
        formatter.maximumFractionDigits = 1
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var newNumber = formatter.numberFromString("\(textField.text)\(string)")
        return newNumber != nil
//        return formatter.numberFromString("\(textField.text)\(string)") != nil
    }
    
}
