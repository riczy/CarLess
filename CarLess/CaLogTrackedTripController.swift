import UIKit
import MapKit

class CaLogTrackedTripController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - UI Properties
    private var scrollView: UIScrollView!
    private var logEntryView: CaLogTrackedTripView!
    private var modePicker: UIPickerView!
    private var categoryPicker: UIPickerView!
    
    // MARK: - Properties
    
    private var categoryData: [Category?] = []
    private var lastSelectedModeIndex = 0
    private var lastSelectedCategoryIndex = 0

    private var mode: Mode? {
        get {
            if lastSelectedModeIndex >= 0 && lastSelectedModeIndex < Mode.allValues.count {
                return Mode.allValues[lastSelectedModeIndex]
            }
            return nil
        }
    }
    
    private var category: Category? {
        get {
            if lastSelectedCategoryIndex > 0 && lastSelectedCategoryIndex < categoryData.count {
                return categoryData[lastSelectedCategoryIndex]
            }
            return nil
        }
    }
    
    private var activeTextField: UITextField?
    
    private struct Tag {
        static let ModePicker = 300
        static let CategoryPicker = 400
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        logEntryView = CaLogTrackedTripView()
        
        scrollView = UIScrollView()
        scrollView.addSubview(logEntryView)
        view.addSubview(scrollView)
        
        logEntryView.startButton.addTarget(self, action: "startTracking", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        // Initialize category data; the first item is nil
        //
        categoryData.append(nil)
        for cat in Category.allValues {
            categoryData.append(cat)
        }
        
        // Dismiss the keyboard on view tap
        //
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        logEntryView.addGestureRecognizer(tap)
        
        modePicker = UIPickerView()
        modePicker.dataSource = self
        modePicker.delegate = self
        modePicker.tag = Tag.ModePicker
        logEntryView.modeTextField.inputView = modePicker

        categoryPicker = UIPickerView()
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        categoryPicker.tag = Tag.CategoryPicker
        logEntryView.categoryTextField.inputView = categoryPicker
        
        // Set the text field delegates to self so that the view knows to where to
        // scroll so that the active text field is not covered when a keyboard
        // appears on the screen.
        //
        logEntryView.modeTextField.delegate = self
        logEntryView.categoryTextField.delegate = self
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
    
    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if identifier == CaSegue.LogTrackedTripHomeToProgress {
            if CaLocationManager.isLocationServiceAvailable() {
                return true
            } else {
                CaLocationManager.requestAlwaysAuthorization()
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == CaSegue.LogTrackedTripHomeToProgress {
            let vc = segue.destinationViewController as! CaLogTrackedTripProgressController
            vc.mode = mode
            vc.category = category
        }
    }
    
    // MARK: - Scene Actions
    
    func startTracking() {
        
        if shouldPerformSegueWithIdentifier(CaSegue.LogTrackedTripHomeToProgress, sender: self) {
            performSegueWithIdentifier(CaSegue.LogTrackedTripHomeToProgress, sender: self)
        }
    }
    
    private func reset() {
        
        lastSelectedModeIndex = 0
        logEntryView.modeTextField.text = Mode.allValues[lastSelectedModeIndex].description
        modePicker.selectRow(lastSelectedModeIndex, inComponent: 0, animated: false)
        
        lastSelectedCategoryIndex = 0
        logEntryView.categoryTextField.text = categoryData[lastSelectedCategoryIndex]?.description
        categoryPicker.selectRow(lastSelectedCategoryIndex, inComponent: 0, animated: false)
    }
    
    
    @IBAction
    func returnToTrackingLogEntryHome(segue: UIStoryboardSegue) {
        
        reset()
    }
    
    
    // MARK: - UIPicker DataSource Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerView.tag == Tag.ModePicker ?
            Mode.allValues.count : categoryData.count
    }
    
    // MARK: - UIPicker Delegate Methods
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerView.tag == Tag.ModePicker ?
            Mode.allValues[row].description :
            categoryData[row]?.description
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == Tag.ModePicker {
            logEntryView.modeTextField.text = Mode.allValues[row].description
            lastSelectedModeIndex = row
            
        } else {
            logEntryView.categoryTextField.text = categoryData[row]?.description
            lastSelectedCategoryIndex = row
        }
    }
    
    // MARK: - UITextField Delegate Methods
    
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
