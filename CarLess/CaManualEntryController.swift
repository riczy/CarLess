import UIKit
import CoreData

class CaManualEntryController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var timestampTextField: UITextField!
    @IBOutlet weak var modeTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var trip = Trip()
    private var lastSelectedModeIndex = 0
    
    private var dateFormatter = NSDateFormatter()
    private var datePicker: UIDatePicker!
    private var modePicker: UIPickerView!
    
    
    private struct Tag {
        static let DistanceField = 200
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle

        initializeDatePicker()
        initializeModePicker()
        initializeDecimalPad()
        
        distanceTextField.tag = Tag.DistanceField
        distanceTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        distanceTextField.keyboardType = UIKeyboardType.DecimalPad
        distanceTextField.delegate = self
        distanceTextField.placeholder = "0.00"
        
        reset()
    }
    
    // MARK: - View Load Initializations
    
    private func initializeDatePicker() {
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        
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
    
    // MARK: - View Actions
    
    @IBAction func saveEntry(sender: UIButton) {
        
        if validate() {
            CaDataManager.instance.saveTrip(trip)
            CaDataManager.instance.fetchAllTrips()
            reset()
        }
    }
    
    private func validate() -> Bool {
        
        // It's impossible for the date and mode values to be nil since they have defaults.
        return trip.distance != nil
    }
    
    private func reset() {
        
        lastSelectedModeIndex = 0

        trip = Trip()
        trip.startTimestamp = NSDate()
        trip.distance = nil
        trip.distanceUnit = LengthUnit.Mile
        trip.logType = LogType.Manual
        trip.mode = Mode.allValues[lastSelectedModeIndex]
        
        timestampTextField.text = dateFormatter.stringFromDate(trip.startTimestamp!)
        distanceTextField.text = ""
        modeTextField.text = trip.mode?.description

        datePicker.date = trip.startTimestamp!
        modePicker.selectRow(lastSelectedModeIndex, inComponent: 0, animated: false)
    }
    
    func datePickerDone() {
        
        trip.startTimestamp = datePicker.date
        timestampTextField.text = dateFormatter.stringFromDate(datePicker.date)
        timestampTextField.resignFirstResponder()
    }
    
    func datePickerCancel() {
        
        timestampTextField.resignFirstResponder()
    }
    
    func decimalPadDone() {
        
        if let tempDistance = Trip.formatter.numberFromString(distanceTextField.text) {
            trip.distance = Double(tempDistance)
        } else {
            trip.distance = nil
        }
        distanceTextField.resignFirstResponder()
    }
    
    func modePickerDone() {
    
        let selectedModeIndex = modePicker.selectedRowInComponent(0)
        if selectedModeIndex > -1 {
            let selectedMode = Mode.allValues[selectedModeIndex]
            modeTextField.text = selectedMode.description
            trip.mode = selectedMode
            lastSelectedModeIndex = selectedModeIndex
        }
        modeTextField.resignFirstResponder()
    }
    
    func modePickerCancel() {
        
        modeTextField.resignFirstResponder()
        modePicker.selectRow(lastSelectedModeIndex, inComponent: 0, animated: false)
    }
    
    // MARK: - UIPicker Delegate Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Mode.allValues.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return Mode.allValues[row].description
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        if textField.tag == Tag.DistanceField {
            return Trip.formatter.numberFromString("\(textField.text)\(string)") != nil
        }
        return true
    }

}
