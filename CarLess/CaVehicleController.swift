import UIKit

class CaVehicleController: UIViewController {
    
    private var _vehicle: Vehicle?
    
    var vehicle: Vehicle? {
        get {
            return _vehicle
        }
        set {
            _vehicle = newValue
        }
    }
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var makeTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var optionsTextField: UITextField!
    
    private var yearPickerView: UIPickerView!
    private var makePickerView: UIPickerView!
    private var modelPickerView: UIPickerView!
    private var optionsPickerView: UIPickerView!
    
    private var yearPickerDelegate: VehicleYearPickerDelegate!
    private var makePickerDelegate: VehicleMakePickerDelegate!
    private var modelPickerDelegate: VehicleModelPickerDelegate!
    private var optionsPickerDelegate: VehicleOptionsPickerDelegate!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        initializeYearPicker()
        initializeMakePicker()
        initializeModelPicker()
        initializeOptionsPicker()
        establishPickerDependencies()
        getVehicle()
    }
    
    private func getVehicle() {
        
        vehicle = CaDataManager.instance.getDefaultVehicle()
        if vehicle != nil {
            yearPickerDelegate.load(selectYear: vehicle!.year)
            makePickerDelegate.load(year: vehicle!.year, selectMake: vehicle!.make)
            modelPickerDelegate.load(year: vehicle!.year, make: vehicle!.make, selectModel: vehicle!.model)
            optionsPickerDelegate.load(year: vehicle!.year, make: vehicle!.make, model: vehicle!.model, selectOption: vehicle!.epaVehicleId)
        }
    }
    
    // MARK: - Picker Initializations
    
    private func establishPickerDependencies() {
    
        optionsPickerDelegate.parentComponent = modelPickerDelegate
        modelPickerDelegate.parentComponent = makePickerDelegate
        makePickerDelegate.parentComponent = yearPickerDelegate
    }
    
    private func initializeYearPicker() {
        
        yearPickerView = UIPickerView()
        yearPickerDelegate = VehicleYearPickerDelegate(pickerView: yearPickerView, textField: yearTextField)
        
        yearPickerView.dataSource = yearPickerDelegate
        yearPickerView.delegate = yearPickerDelegate
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: yearPickerDelegate, action: Selector("done"))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: yearPickerDelegate, action: Selector("cancel"))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        
        yearTextField.inputView = yearPickerView
        yearTextField.inputAccessoryView = toolbar
        
        yearPickerDelegate.load()
    }
    
    private func initializeMakePicker() {
        
        makePickerView = UIPickerView()
        makePickerDelegate = VehicleMakePickerDelegate(pickerView: makePickerView, textField: makeTextField)
        
        makePickerView.dataSource = makePickerDelegate
        makePickerView.delegate = makePickerDelegate
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: makePickerDelegate, action: Selector("done"))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: makePickerDelegate, action: Selector("cancel"))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        
        makeTextField.inputView = makePickerView
        makeTextField.inputAccessoryView = toolbar
    }

    private func initializeModelPicker() {
        
        modelPickerView = UIPickerView()
        modelPickerDelegate = VehicleModelPickerDelegate(pickerView: modelPickerView, textField: modelTextField)
        
        modelPickerView.dataSource = modelPickerDelegate
        modelPickerView.delegate = modelPickerDelegate
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: modelPickerDelegate, action: Selector("done"))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: modelPickerDelegate, action: Selector("cancel"))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        
        modelTextField.inputView = modelPickerView
        modelTextField.inputAccessoryView = toolbar
    }
    
    private func initializeOptionsPicker() {
        
        optionsPickerView = UIPickerView()
        optionsPickerDelegate = VehicleOptionsPickerDelegate(pickerView: optionsPickerView, textField: optionsTextField)
        
        optionsPickerView.dataSource = optionsPickerDelegate
        optionsPickerView.delegate = optionsPickerDelegate
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: optionsPickerDelegate, action: Selector("done"))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: optionsPickerDelegate, action: Selector("cancel"))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        
        optionsTextField.inputView = optionsPickerView
        optionsTextField.inputAccessoryView = toolbar
    }

    @IBAction func save(sender: UIBarButtonItem) {
        
        let epaVehicle = self.optionsPickerDelegate.vehicle
        if !validate() || epaVehicle == nil {
            NSLog("The vehicle did not pass validation; cannot save it.")
            return
        }

        let defaultVehicleReferenceCount = CaDataManager.instance.countTripsUsedByVehicle(vehicle)
        if vehicle == nil || defaultVehicleReferenceCount > 0 {
            // If the default vehicle does not already exist then create it with
            // the scene's settings. Or, if the default vehicle does exist and it
            // is being referenced by trips then create a new vehicle instance
            // and set this new instance as the default vehicle.
            vehicle = CaDataManager.instance.initVehicle()
            epaVehicle!.setPropertiesForVehicle(vehicle!)
            CaDataManager.instance.save(vehicle: vehicle!)
            CaDataManager.instance.saveDefaultSetting(vehicle: vehicle)
        } else {
            // Update the current default vehicle with the new values. We can do
            // this because it is not yet being referenced by any trips.
            epaVehicle!.setPropertiesForVehicle(vehicle!)
            CaDataManager.instance.save(vehicle: vehicle!)
        }
        exit()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        yearPickerDelegate.reset()
        exit()
    }
    
    private func exit() {
        performSegueWithIdentifier(CaSegue.VehicleToSettings, sender: self)
    }
    
    ///
    /// Returns true if the form is properly filled out and may be saved.
    /// Returns false if not.
    ///
    private func validate() -> Bool {
        return optionsPickerDelegate.selectedItem != nil
    }
    
    private func foo() {
        
        // Is new vehicle different than old one? If no then don't save.
        let defaultVehicle = CaDataManager.instance.getDefaultVehicle()
        
        // Is old vehicle referenced by any trips?
        // If yes then create a new instance for vehicle and save.
        // If no then update the current instance and save.
        if defaultVehicle != nil {
            
        }
    }
}
