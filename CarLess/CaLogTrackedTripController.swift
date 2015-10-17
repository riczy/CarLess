import UIKit
import MapKit

class CaLogTrackedTripController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - UI Properties
    
    private var headingLabel: UILabel!
    private var modeTextField: UITextField!
    private var modeHrView: UIView!
    private var modePicker: UIPickerView!
    private var startButton: UIButton!
    
    // MARK: - Properties
    
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
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setComponents()
        setConstraints()
        reset()
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
        
        modeTextField.inputView = modePicker
        modeTextField.inputAccessoryView = toolbar
    }
   
    private func updateDisplayForMode(mode: Mode) {
        
        modeTextField.text = mode.description
    }
    
    // MARK: - Scene Actions
    
    func modePickerDone() {
        
        let selectedModeIndex = modePicker.selectedRowInComponent(0)
        if selectedModeIndex > -1 {
            mode = Mode.allValues[selectedModeIndex]
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return Mode.allValues[row].description
    }
    
    // MARK: - View Construction
    
    private func setComponents() {

        view.backgroundColor = CaStyle.ViewBgColor
        
        headingLabel = UILabel()
        headingLabel.font = CaStyle.InstructionHeadlineFont
        headingLabel.numberOfLines = 0
        headingLabel.text = "Begin tracking your trip by choosing the transportation mode"
        headingLabel.textAlignment = NSTextAlignment.Center
        headingLabel.textColor = CaStyle.InstructionHeadlineColor
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headingLabel)
        
        modeTextField = UITextField()
        modeTextField.adjustsFontSizeToFitWidth = true
        modeTextField.borderStyle = UITextBorderStyle.None
        modeTextField.font = CaStyle.InputFieldFont
        modeTextField.minimumFontSize = CaStyle.InputFieldFontMinimumScaleFactor
        modeTextField.placeholder = "Mode"
        modeTextField.textAlignment = NSTextAlignment.Center
        modeTextField.textColor = CaStyle.InputFieldColor
        modeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeTextField)
        
        modeHrView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: CaStyle.InputFieldHrThickness))
        modeHrView.backgroundColor = CaStyle.InputFieldHrColor
        modeHrView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modeHrView)
        
        initializeModePicker()
        
        startButton = CaComponent.createButton(title: "Start tracking", color: CaStyle.LogStartButtonColor, bgColor: CaStyle.LogStartButtonBgColor, borderColor: CaStyle.LogStartButtonBorderColor)
        startButton.addTarget(self, action: "startTracking", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(startButton)
    }
    
    private func setConstraints() {
        
        view.addConstraint(NSLayoutConstraint(item: headingLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 30.0))
        view.addConstraint(NSLayoutConstraint(item: headingLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: headingLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        
        view.addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: headingLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        view.addConstraint(NSLayoutConstraint(item: modeHrView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeTextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupHrVerticlePadding))
        view.addConstraint(NSLayoutConstraint(item: modeHrView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.InputFieldHrThickness))
        view.addConstraint(NSLayoutConstraint(item: modeHrView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        view.addConstraint(NSLayoutConstraint(item: modeHrView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        
        view.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: -30.0))
        view.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonWidth))
        view.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonHeight))
    }
}
