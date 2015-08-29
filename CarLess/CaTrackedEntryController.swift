import UIKit
import MapKit

class CaTrackedEntryController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var modeImage: UIImageView!
    @IBOutlet weak var modeTextField: UITextField!
    
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeModePicker()
        reset()
    }
    

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
    
    
    private func reset() {
        
        lastSelectedModeIndex = 0
        mode = Mode.allValues[lastSelectedModeIndex]
    }
    
    
    @IBAction
    func returnToTrackingLogEntryHome(segue: UIStoryboardSegue) {
        
        reset()
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
        
        modePicker.selectRow(lastSelectedModeIndex, inComponent: 0, animated: false)
    }
    
    private func updateDisplayForMode(mode: Mode) {
        
        modeTextField.text = mode.description
        modeImage?.image = UIImage(named: mode.imageFilename)
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return Mode.allValues[row].description
    }
    
}
