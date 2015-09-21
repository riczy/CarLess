import UIKit
import MapKit

class CaTrackedEntryController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: - UI Properties
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var modeTextField: UITextField!
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
        initializeStyle()
        initializeModePicker()
        renderStartButton()
        reset()
    }
    
    // MARK: - Navigation

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if identifier == CaSegue.TrackedHomeToProgress {
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
        
        if segue.identifier == CaSegue.TrackedHomeToProgress {
            let vc = segue.destinationViewController as! CaTrackedProgressController
            vc.mode = mode
        }
    }
    
    // MARK: - Scene Actions
    
    func startTracking() {
        
        if shouldPerformSegueWithIdentifier(CaSegue.TrackedHomeToProgress, sender: self) {
            performSegueWithIdentifier(CaSegue.TrackedHomeToProgress, sender: self)
        }
    }
    
    private func reset() {
        
        lastSelectedModeIndex = 0
        mode = Mode.allValues[lastSelectedModeIndex]
    }
    
    
    @IBAction
    func returnToTrackingLogEntryHome(segue: UIStoryboardSegue) {
        
        reset()
    }
    
    // MARK: - View Initializations
    
    private func initializeStyle() {
        
        view.backgroundColor = CaLogStyle.ViewBgColor
        headingLabel.textColor = CaLogStyle.ViewLabelColor
        modeTextField.textColor = CaLogStyle.ViewFieldColor
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
        
        modePicker.selectRow(lastSelectedModeIndex, inComponent: 0, animated: false)
    }
    
    private func renderStartButton() {
        
        startButton = CaComponent.createButton(title: "Start", color: CaLogStyle.StartButtonColor, bgColor: CaLogStyle.StartButtonBgColor, borderColor: CaLogStyle.StartButtonBorderColor)
        self.view.addSubview(startButton)
        
        
        view.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.BottomMargin, multiplier: 1.0, constant: -20.0))
        view.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonWidth))
        view.addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonHeight))
        
        startButton.addTarget(self, action: "startTracking", forControlEvents: UIControlEvents.TouchUpInside)
    }
   
    private func updateDisplayForMode(mode: Mode) {
        
        modeTextField.text = mode.description
        //modeImage?.image = UIImage(named: mode.imageFilename)
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
    
}
