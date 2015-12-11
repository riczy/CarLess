import UIKit
import MapKit

class CaLogTrackedTripController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    private var scrollView: UIScrollView!
    private var entryView: CaLogTrackedTripView!
    private var modePicker: UIPickerView!
    
    private var lastSelectedModeIndex = 0

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
    
    private var activeTextField: UITextField?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        entryView = CaLogTrackedTripView()
        
        scrollView = UIScrollView()
        scrollView.addSubview(entryView)
        view.addSubview(scrollView)
        
        entryView.startButton.addTarget(self, action: "startTracking", forControlEvents: UIControlEvents.TouchUpInside)
        initializeModePicker()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        entryView.addGestureRecognizer(tap)

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
        entryView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - topLayoutGuide.length - bottomLayoutGuide.length)
        scrollView.frame = entryView.frame
        scrollView.contentSize = entryView.frame.size
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
        mode = Mode.allValues[lastSelectedModeIndex]
        modePicker.selectRow(lastSelectedModeIndex, inComponent: 0, animated: false)
    }
    
    
    @IBAction
    func returnToTrackingLogEntryHome(segue: UIStoryboardSegue) {
        
        reset()
    }
    
    // MARK: - View Initializations
    
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
        
        entryView.modeTextField.inputView = modePicker
        entryView.modeTextField.inputAccessoryView = toolbar
    }
   
    private func updateDisplayForMode(mode: Mode) {
        
        entryView.modeTextField.text = mode.description
    }
    
    // MARK: - Scene Actions
    
    func modePickerDone() {
        
        let selectedModeIndex = modePicker.selectedRowInComponent(0)
        if selectedModeIndex > -1 {
            mode = Mode.allValues[selectedModeIndex]
            lastSelectedModeIndex = selectedModeIndex
        }
        entryView.modeTextField.resignFirstResponder()
    }
    
    func modePickerCancel() {
        
        entryView.modeTextField.resignFirstResponder()
        modePicker.selectRow(lastSelectedModeIndex, inComponent: 0, animated: false)
    }
    
    // MARK: - UIPicker Delegate Methods
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return Mode.allValues.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Mode.allValues[row].description
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
