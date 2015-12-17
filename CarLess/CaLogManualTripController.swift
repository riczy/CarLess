import UIKit
import CoreData

class CaLogManualTripController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - UI Properties
    
    private var scrollView: UIScrollView!
    private var logEntryView: CaLogManualTripView!
    private var datePicker: UIDatePicker!
    private var modePicker: UIPickerView!
    private var spinnerView: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var distance: NSNumber? {
        get {
            if logEntryView.distanceTextField.text != nil {
                if let tempDistance = CaFormatter.distance.numberFromString(logEntryView.distanceTextField.text!) {
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
    
    private var activeTextField: UITextField?
 
    private var trip: Trip?
    private var lastSelectedModeIndex = 0
    
    private struct Tag {
        static let DistanceField = 200
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logEntryView = CaLogManualTripView()
        
        scrollView = UIScrollView()
        scrollView.addSubview(logEntryView)
        view.addSubview(scrollView)
        
        logEntryView.saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        
        spinnerView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        spinnerView.color = CaStyle.ActivitySpinnerColor
        spinnerView.hidesWhenStopped = true
        spinnerView.center = view.center
        view.addSubview(spinnerView)
        
        logEntryView.distanceTextField.tag = Tag.DistanceField
        logEntryView.distanceTextField.delegate = self
        logEntryView.modeTextField.delegate = self
        logEntryView.timestampTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        logEntryView.addGestureRecognizer(tap)
        
        initializeDatePicker()
        initializeModePicker()
        initializeDecimalPad()
    }
    
    override func viewDidAppear(animated: Bool) {
        reset()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterFromKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logEntryView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - topLayoutGuide.length - bottomLayoutGuide.length)
        scrollView.frame = logEntryView.frame
        scrollView.contentSize = logEntryView.frame.size
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

        logEntryView.timestampTextField.inputView = datePicker
        logEntryView.timestampTextField.inputAccessoryView = toolbar
    }
    
    private func initializeDecimalPad() {
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("decimalPadDone"))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)

        toolbar.setItems([spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        
        logEntryView.distanceTextField.inputAccessoryView = toolbar
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
       
        logEntryView.modeTextField.inputView = modePicker
        logEntryView.modeTextField.inputAccessoryView = toolbar
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
            FuelPriceFinder.instance.fuelPrice(forDate: trip.startTimestamp, onSuccess: onFuelPriceFindSuccess, onError: onFuelPriceFindError)
       }
    }
    
    private func validate() -> Bool {

        return distance?.doubleValue > 0.0 && mode != nil
    }
    
    private func preSave() {
        
        view.alpha = CaConstants.SaveDisplayAlpha
        logEntryView.saveButton.enabled = false
        spinnerView.startAnimating()
    }
    
    private func postSave() {
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(CaConstants.SaveActivityDelay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.spinnerView.stopAnimating()
            self.logEntryView.saveButton.enabled = true
            self.view.alpha = 1.0
            self.performSegueWithIdentifier(CaSegue.LogManualTripHomeToSummary, sender: self)
       }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == CaSegue.LogManualTripHomeToSummary {
            let vc = segue.destinationViewController as! LogManualTripSummaryController
            vc.trip = self.trip
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
        logEntryView.timestampTextField.text = CaFormatter.timestamp.stringFromDate(datePicker.date)
        
        logEntryView.distanceTextField.text = nil
        logEntryView.distanceTextField.placeholder = "0.0 \(CaDataManager.instance.defaultDistanceUnit.rawValue.lowercaseString)s"
        
        lastSelectedModeIndex = 0
        logEntryView.modeTextField.text = Mode.allValues[lastSelectedModeIndex].description
        modePicker.selectRow(lastSelectedModeIndex, inComponent: 0, animated: false)
    }
    
    @IBAction
    func returnToManualLogEntryHome(segue: UIStoryboardSegue) {
        
        reset()
    }
    
    func datePickerDone() {
        
        logEntryView.timestampTextField.text = CaFormatter.timestamp.stringFromDate(datePicker.date)
        logEntryView.timestampTextField.resignFirstResponder()
    }
    
    func datePickerCancel() {
        
        logEntryView.timestampTextField.resignFirstResponder()
    }
    
    func decimalPadDone() {
        
        logEntryView.distanceTextField.resignFirstResponder()
    }
    
    func modePickerDone() {
    
        let selectedModeIndex = modePicker.selectedRowInComponent(0)
        if selectedModeIndex > -1 {
            let selectedMode = Mode.allValues[selectedModeIndex]
            logEntryView.modeTextField.text = selectedMode.description
            lastSelectedModeIndex = selectedModeIndex
        }
        logEntryView.modeTextField.resignFirstResponder()
    }
    
    func modePickerCancel() {
        
        logEntryView.modeTextField.resignFirstResponder()
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        activeTextField = nil
    }
    
    // MARK: - Keyboard
    
    func registerForKeyboardNotifications() {
        
        let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unregisterFromKeyboardNotifications() {
        
        let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification) {
        
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue as CGRect!).size
        
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        var tempRect = self.view.frame
        tempRect.size.height -= keyboardSize.height;
        if activeTextField != nil {
            let containsPoint = CGRectContainsPoint(tempRect, activeTextField!.frame.origin)
            if !containsPoint {
                scrollView.scrollRectToVisible(activeTextField!.frame, animated: true)
            }
        }
    }

    func keyboardWillBeHidden(notification: NSNotification) {
        
        let contentInsets = UIEdgeInsets(top: topLayoutGuide.length, left: 0.0, bottom: bottomLayoutGuide.length, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
        activeTextField?.resignFirstResponder()
    }

}
