import UIKit

class CaManualEntryController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var timestampTextField: UITextField!
    @IBOutlet weak var modeTextField: UITextField!
    
    var trip = Trip()
    
    var dateFormatter = NSDateFormatter()
    var datePicker: UIDatePicker!
    var modePicker: UIPickerView!
    
    private struct Tag {
        static let DistanceField = 200
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle

        trip.date = NSDate()
        trip.distance = 0.0
        trip.distanceUnit = LengthUnit.Mile
        trip.mode = Mode.allValues.first
        
        timestampTextField.text = dateFormatter.stringFromDate(trip.date!)
        initializeDatePicker()
        
        distanceTextField.tag = Tag.DistanceField
        distanceTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        distanceTextField.keyboardType = UIKeyboardType.DecimalPad
        distanceTextField.delegate = self
        distanceTextField.text = ""
        distanceTextField.placeholder = "-.--"
        initializeDecimalPad()
        
        modeTextField.text = trip.mode?.description
        initializeModePicker()
        
    }
    
    private func initializeDatePicker() {
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        datePicker.date = trip.date!
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("datePickerDone"))
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("datePickerCancel"))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true

        timestampTextField.inputView = datePicker
        timestampTextField.inputAccessoryView = toolbar
    }
    
    private func initializeDecimalPad() {
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("decimalPadDone"))
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)

        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        
        distanceTextField.inputAccessoryView = toolbar
    }
    
    private func initializeModePicker() {
        
        modePicker = UIPickerView()
        modePicker.dataSource = self
        modePicker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("modePickerDone"))
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("modePickerCancel"))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
       
        modeTextField.inputView = modePicker
        modeTextField.inputAccessoryView = toolbar
    }
    
    func datePickerDone() {
        
        timestampTextField.text = dateFormatter.stringFromDate(datePicker.date)
        timestampTextField.resignFirstResponder()
    }
    
    func datePickerCancel() {
        
        timestampTextField.resignFirstResponder()
    }
    
    func decimalPadDone() {
        
        distanceTextField.resignFirstResponder()
    }
    
    func modePickerDone() {
    
        let selectedRow = modePicker.selectedRowInComponent(0)
        if selectedRow > -1 {
            modeTextField.text = Mode.allValues[selectedRow].description
        }
        modeTextField.resignFirstResponder()
    }
    
    func modePickerCancel() {
        
        modeTextField.resignFirstResponder()
        // TODO: - Need to save the mode (lastSelectedModeIndex) so that picker can be reset
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Mode.allValues.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return Mode.allValues[row].description
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        if textField.tag == Tag.DistanceField {
            return Trip.formatter.numberFromString("\(textField.text)\(string)") != nil
        }
        return true
    }

}
