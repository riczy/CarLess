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
        
        vehicle = CaDataManager.instance.fetchVehicle()
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
        
        // TODO: put in some warning if validation fails or vehicle is nil
        
        let epaVehicle = self.optionsPickerDelegate.vehicle
        if validate() && epaVehicle != nil {
            let newVehicle = CaDataManager.instance.initVehicle()
            newVehicle.epaVehicleId = epaVehicle!.id
            newVehicle.year = epaVehicle!.year
            newVehicle.make = epaVehicle!.make
            newVehicle.model = epaVehicle!.model
            CaDataManager.instance.save(vehicle: newVehicle)
            performSegueWithIdentifier(CaSegue.VehicleToSettingsHome, sender: self)
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        yearPickerDelegate.reset()
        performSegueWithIdentifier(CaSegue.VehicleToSettingsHome, sender: self)
    }
    
    ///
    /// Returns true if the form is properly filled out and may be saved.
    /// Returns false if not.
    ///
    private func validate() -> Bool {
        return optionsPickerDelegate.selectedItem != nil
    }
    
}
