import UIKit
import CoreData

class CaLogManualTripController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - UI Properties
    
    private var distanceLabel: UILabel!
    private var distanceTextField: UITextField!
    private var distanceHrView: UIView!
    private var timestampLabel: UILabel!
    private var timestampTextField: UITextField!
    private var timestampHrView: UIView!
    private var modeLabel: UILabel!
    private var modeTextField: UITextField!
    private var modeHrView: UIView!
    private var saveButton: UIButton!
    private var datePicker: UIDatePicker!
    private var modePicker: UIPickerView!
    private var spinnerView: UIActivityIndicatorView!
    
    private var distance: NSNumber? {
        get {
            if distanceTextField.text != nil {
                if let tempDistance = CaFormatter.distance.numberFromString(distanceTextField.text!) {
                    return tempDistance
                }
            }
            return nil
        }
    }
    
    private var mode: Mode? {
        get {
            if lastSelectedModeIndex >= 0 && lastSelectedModeIndex < Mode.allValues.count {
                return Mode.allValues[lastSelectedModeIndex]
            }
            return nil
        }
    }
    
 
    // MARK: - Properties
    private var trip: Trip?
    private var lastSelectedModeIndex = 0
    
    private struct Tag {
        static let DistanceField = 200
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setComponents()
        setConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        reset()
    }
    
    // MARK: - View Initializations
    
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
    
    // MARK: - View Actions
    
    func save() {

        if validate() {
            let trip = createTrip()
            preSave()
            let onFuelPriceFindSuccess = {(fuelPrice: EiaWeeklyFuelPrice) -> Void in
                trip.fuelPrice = fuelPrice.price
                trip.fuelPriceDate = fuelPrice.startDate
                trip.fuelPriceSeriesId = fuelPrice.seriesId
                CaDataManager.instance.save(trip: trip)
                self.trip = trip
                self.postSave()
            }
            let onFuelPriceFindError = {() -> Void in
                CaDataManager.instance.save(trip: trip)
                self.trip = trip
                self.postSave()
            }
            CaFuelPriceFinder.instance.fuelPrice(forDate: trip.startTimestamp, onSuccess: onFuelPriceFindSuccess, onError: onFuelPriceFindError)
       }
    }
    
    private func validate() -> Bool {

        return distance?.doubleValue > 0.0 && mode != nil
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
            self.performSegueWithIdentifier(CaSegue.LogManualTripHomeToSummary, sender: self)
       }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == CaSegue.LogManualTripHomeToSummary {
            let vc = segue.destinationViewController as! CaLogTripSummaryController
            vc.trip = self.trip
            vc.isSaveableSummary = false
            vc.exitSegue = CaSegue.LogManualTripSummaryToHome
        }
    }
    
    private func createTrip() -> Trip {
    
        let trip = CaDataManager.instance.initTrip()
        
        if let tempDistance = distance {
            trip.setDistance(tempDistance, hasUnitType: CaDataManager.instance.defaultDistanceUnit)
        } else {
            trip.setDistance(0.0, hasUnitType: CaDataManager.instance.defaultDistanceUnit)
        }
        trip.logType = LogType.Manual
        trip.modeType = mode!
        trip.pending = false
        trip.startTimestamp = datePicker.date
        trip.endTimestamp = nil
        
        return trip
    }
    
    func reset() {
        
        trip = nil
        
        datePicker.date = NSDate()
        datePicker.maximumDate = datePicker.date.addDays(1)
        timestampTextField.text = CaFormatter.timestamp.stringFromDate(datePicker.date)
        
        distanceTextField.text = nil
        distanceTextField.placeholder = "0.0 \(CaDataManager.instance.defaultDistanceUnit.rawValue.lowercaseString)s"
        
        lastSelectedModeIndex = 0
        modeTextField.text = Mode.allValues[lastSelectedModeIndex].description
        modePicker.selectRow(lastSelectedModeIndex, inComponent: 0, animated: false)
    }
    
    @IBAction
    func returnToManualLogEntryHome(segue: UIStoryboardSegue) {
        
        reset()
    }
    
    func datePickerDone() {
        
        timestampTextField.text = CaFormatter.timestamp.stringFromDate(datePicker.date)
        timestampTextField.resignFirstResponder()
    }
    
    func datePickerCancel() {
        
        timestampTextField.resignFirstResponder()
    }
    
    func decimalPadDone() {
        
        distanceTextField.resignFirstResponder()
    }
    
    func modePickerDone() {
    
        let selectedModeIndex = modePicker.selectedRowInComponent(0)
        if selectedModeIndex > -1 {
            let selectedMode = Mode.allValues[selectedModeIndex]
            modeTextField.text = selectedMode.description
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
    
    // MARK: - View Construction
    
    private func setComponents() {
        
        let alignment = NSTextAlignment.Center
        view.backgroundColor = CaStyle.ViewBgColor
        
        timestampLabel = UILabel()
        timestampLabel.font = CaStyle.InputLabelFont
        timestampLabel.text = "Start date and time"
        timestampLabel.textAlignment = alignment
        timestampLabel.textColor = CaStyle.InputLabelColor
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timestampLabel)
        
        timestampTextField = UITextField()
        timestampTextField.adjustsFontSizeToFitWidth = true
        timestampTextField.borderStyle = UITextBorderStyle.None
        timestampTextField.font = CaStyle.InputFieldFont
        timestampTextField.minimumFontSize = CaStyle.InputFieldFontMinimumScaleFactor
        timestampTextField.placeholder = "Start date and time"
        timestampTextField.textAlignment = alignment
        timestampTextField.textColor = CaStyle.InputFieldColor
        timestampTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timestampTextField)
        
        timestampHrView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CaStyle.InputFieldHrThickness))
        timestampHrView.backgroundColor = CaStyle.InputFieldHrColor
        timestampHrView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(timestampHrView)
        
        modeLabel = UILabel()
        modeLabel.font = CaStyle.InputLabelFont
        modeLabel.text = "Mode"
        modeLabel.textAlignment = alignment
        modeLabel.textColor = CaStyle.InputLabelColor
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeLabel)

        modeTextField = UITextField()
        modeTextField.adjustsFontSizeToFitWidth = true
        modeTextField.borderStyle = UITextBorderStyle.None
        modeTextField.font = CaStyle.InputFieldFont
        modeTextField.minimumFontSize = CaStyle.InputFieldFontMinimumScaleFactor
        modeTextField.placeholder = "Mode"
        modeTextField.textAlignment = alignment
        modeTextField.textColor = CaStyle.InputFieldColor
        modeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeTextField)
        
        modeHrView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CaStyle.InputFieldHrThickness))
        modeHrView.backgroundColor = CaStyle.InputFieldHrColor
        modeHrView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeHrView)

        distanceLabel = UILabel()
        distanceLabel.font = CaStyle.InputLabelFont
        distanceLabel.text = "Distance"
        distanceLabel.textAlignment = alignment
        distanceLabel.textColor = CaStyle.InputLabelColor
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distanceLabel)
        
        distanceTextField = UITextField()
        distanceTextField.adjustsFontSizeToFitWidth = true
        distanceTextField.borderStyle = UITextBorderStyle.None
        distanceTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        distanceTextField.delegate = self
        distanceTextField.font = CaStyle.InputFieldFont
        distanceTextField.keyboardType = UIKeyboardType.DecimalPad
        distanceTextField.minimumFontSize = CaStyle.InputFieldFontMinimumScaleFactor
        distanceTextField.tag = Tag.DistanceField
        distanceTextField.textAlignment = alignment
        distanceTextField.textColor = CaStyle.InputFieldColor
        distanceTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distanceTextField)
        
        distanceHrView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CaStyle.InputFieldHrThickness))
        distanceHrView.backgroundColor = CaStyle.InputFieldHrColor
        distanceHrView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(distanceHrView)
        
        saveButton = CaComponent.createButton(title: "Save trip", color: CaStyle.LogSaveButtonColor, bgColor: CaStyle.LogSaveButtonBgColor, borderColor: CaStyle.LogSaveButtonBorderColor)
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(saveButton)

        spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        spinnerView.center = view.center
        spinnerView.color = CaStyle.ActivitySpinnerColor
        spinnerView.hidesWhenStopped = true
        view.addSubview(spinnerView)

        initializeDatePicker()
        initializeModePicker()
        initializeDecimalPad()
    }
    
    private func setConstraints() {
        
        
        view.addConstraint(NSLayoutConstraint(item: timestampLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 30.0))
        view.addConstraint(NSLayoutConstraint(item: timestampLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: timestampLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        view.addConstraint(NSLayoutConstraint(item: timestampTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: timestampLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupLvVerticlePadding))
        view.addConstraint(NSLayoutConstraint(item: timestampTextField, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: timestampTextField, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        view.addConstraint(NSLayoutConstraint(item: timestampHrView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: timestampTextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupHrVerticlePadding))
        view.addConstraint(NSLayoutConstraint(item: timestampHrView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.InputFieldHrThickness))
        view.addConstraint(NSLayoutConstraint(item: timestampHrView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: timestampHrView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        
        view.addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: timestampHrView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupVerticlePadding))
        view.addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        view.addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupLvVerticlePadding))
        view.addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        view.addConstraint(NSLayoutConstraint(item: modeHrView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeTextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupHrVerticlePadding))
        view.addConstraint(NSLayoutConstraint(item: modeHrView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.InputFieldHrThickness))
        view.addConstraint(NSLayoutConstraint(item: modeHrView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: modeHrView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        
        view.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeHrView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupVerticlePadding))
        view.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        view.addConstraint(NSLayoutConstraint(item: distanceTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: distanceLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupLvVerticlePadding))
        view.addConstraint(NSLayoutConstraint(item: distanceTextField, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: distanceTextField, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        view.addConstraint(NSLayoutConstraint(item: distanceHrView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: distanceTextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupHrVerticlePadding))
        view.addConstraint(NSLayoutConstraint(item: distanceHrView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.InputFieldHrThickness))
        view.addConstraint(NSLayoutConstraint(item: distanceHrView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: distanceHrView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: -30.0))
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonWidth))
        view.addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonHeight))

    }

}
