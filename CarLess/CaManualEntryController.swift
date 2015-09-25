import UIKit
import CoreData

class CaManualEntryController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - UI Properties
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var timestampTextField: UITextField!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var modeTextField: UITextField!
    private var saveButton: UIButton!
    private var datePicker: UIDatePicker!
    private var modePicker: UIPickerView!
    private var spinnerView: UIActivityIndicatorView!
    
 
    // MARK: - Properties
    
    private var trip: Trip!
    private var lastSelectedModeIndex = 0
    private var distanceDisplayUnit: LengthUnit!
    
    private struct Tag {
        static let DistanceField = 200
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        initializeDatePicker()
        initializeModePicker()
        initializeDecimalPad()
        initializeSpinner()
        renderSaveButton()
        initializeStyle()
        reset()
        
        distanceTextField.tag = Tag.DistanceField
        distanceTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        distanceTextField.keyboardType = UIKeyboardType.DecimalPad
        distanceTextField.delegate = self
        distanceTextField.placeholder = "0.00"
        distanceDisplayUnit = CaDataManager.instance.getDefaultDistanceUnit()
        
    }
    
    // MARK: - View Initializations
    
    private func initializeStyle() {
        
        view.backgroundColor = CaLogStyle.ViewBgColor
        
        distanceLabel.textColor = CaLogStyle.ViewLabelColor
        timestampLabel.textColor = CaLogStyle.ViewLabelColor
        modeLabel.textColor = CaLogStyle.ViewLabelColor
        
        distanceTextField.textColor = CaLogStyle.ViewFieldColor
        timestampTextField.textColor = CaLogStyle.ViewFieldColor
        modeTextField.textColor = CaLogStyle.ViewFieldColor
        
        spinnerView.color = CaLogStyle.ActivitySpinnerColor
    }
    
    private func renderSaveButton() {
        
        saveButton = CaComponent.createButton(title: "Save", color: CaLogStyle.SaveButtonColor, bgColor: CaLogStyle.SaveButtonBgColor, borderColor: CaLogStyle.SaveButtonBorderColor)
        self.view.addSubview(saveButton)
        
        
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: -20.0))
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonWidth))
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonHeight))
        
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    private func initializeDatePicker() {
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePickerMode.DateAndTime
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("datePickerDone"))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("datePickerCancel"))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true

        timestampTextField.inputView = datePicker
        timestampTextField.inputAccessoryView = toolbar
    }
    
    private func initializeDecimalPad() {
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("decimalPadDone"))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)

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
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("modePickerDone"))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("modePickerCancel"))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
       
        modeTextField.inputView = modePicker
        modeTextField.inputAccessoryView = toolbar
    }
    
    private func initializeSpinner() {
        
        spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        spinnerView.center = view.center
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)
    }
    
    // MARK: - View Actions
    
    func save() {

        if validate() {
            preSave()
            CaDataManager.instance.save(trip: trip)
            postSave()
        }
    }
    
    private func validate() -> Bool {
        
        return trip.distance.doubleValue > 0.0
    }
    
    private func preSave() {
        
        view.alpha = CaConstants.SaveDisplayAlpha
        saveButton.enabled = false
        spinnerView.startAnimating()
    }
    
    private func postSave() {
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(CaConstants.SaveActivityDelay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.spinnerView.stopAnimating()
            self.saveButton.enabled = true
            self.view.alpha = 1.0
            self.reset()
        }
    }
    
    private func reset() {
        
        lastSelectedModeIndex = 0
        
        trip = CaDataManager.instance.initTrip()
        trip.distance = 0.0
        trip.logType = LogType.Manual
        trip.modeType = Mode.allValues[lastSelectedModeIndex]
        trip.startTimestamp = NSDate()
        trip.endTimestamp = nil
        
        timestampTextField.text = CaFormatter.timestamp.stringFromDate(trip.startTimestamp)
        distanceTextField.text = ""
        modeTextField.text = trip.modeType.description
        
        datePicker.date = trip.startTimestamp
        modePicker.selectRow(lastSelectedModeIndex, inComponent: 0, animated: false)
    }
    
    func datePickerDone() {
        
        trip.startTimestamp = datePicker.date
        timestampTextField.text = CaFormatter.timestamp.stringFromDate(datePicker.date)
        timestampTextField.resignFirstResponder()
    }
    
    func datePickerCancel() {
        
        timestampTextField.resignFirstResponder()
    }
    
    func decimalPadDone() {
        
        if let tempDistance = CaFormatter.distance.numberFromString(distanceTextField.text!) {
            trip.setDistance(tempDistance, hasUnitType: distanceDisplayUnit)
        } else {
            trip.setDistance(0.0, hasUnitType: distanceDisplayUnit)
        }
        distanceTextField.resignFirstResponder()
    }
    
    func modePickerDone() {
    
        let selectedModeIndex = modePicker.selectedRowInComponent(0)
        if selectedModeIndex > -1 {
            let selectedMode = Mode.allValues[selectedModeIndex]
            modeTextField.text = selectedMode.description
            trip.modeType = selectedMode
            lastSelectedModeIndex = selectedModeIndex
        }
        modeTextField.resignFirstResponder()
    }
    
    func modePickerCancel() {
        
        modeTextField.resignFirstResponder()
        modePicker.selectRow(lastSelectedModeIndex, inComponent: 0, animated: false)
    }
    
    // MARK: - Mode UIPicker DataSource Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Mode.allValues.count;
    }
    
    // MARK: - Mode UIPicker Delegate Methods
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Mode.allValues[row].description
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
 
        if textField.tag == Tag.DistanceField {
            let textFieldText = textField.text == nil ? "" : textField.text!
            return CaFormatter.distance.numberFromString("\(textFieldText)\(string)") != nil
        }
        return true
    }

}
