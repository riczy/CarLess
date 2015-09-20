import UIKit

class CaVehicleController: UIViewController {
    
    private var _vehicle: Vehicle?
    
    var vehicle: Vehicle? {
        get {
            return _vehicle
        }
        set {
            _vehicle = newValue
            println("Setting vehicle")
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
            // reset everything
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
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: yearPickerDelegate, action: Selector("done"))
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: yearPickerDelegate, action: Selector("cancel"))
        
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
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: makePickerDelegate, action: Selector("done"))
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: makePickerDelegate, action: Selector("cancel"))
        
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
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: modelPickerDelegate, action: Selector("done"))
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: modelPickerDelegate, action: Selector("cancel"))
        
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
        
        var doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: optionsPickerDelegate, action: Selector("done"))
        var spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: optionsPickerDelegate, action: Selector("cancel"))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolbar.userInteractionEnabled = true
        
        optionsTextField.inputView = optionsPickerView
        optionsTextField.inputAccessoryView = toolbar
    }

    @IBAction func save(sender: UIBarButtonItem) {
        
        // TODO: put in some warning if validation fails or vehicle is nil
        
        let epaVehicle = self.optionsPickerDelegate.vehicle
        if validate() && epaVehicle != nil {
            var newVehicle = CaDataManager.instance.initVehicle()
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

///
/// Manages a vehicle menu item text field's picker by implementing data source
/// and picker view delegate functionality. The individual text field managers
/// for year, make, model and options will inherit from this class.
///
class VehiclePickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseUrl = NSURL(string: "http://www.fueleconomy.gov")
    var data = [EpaVehicleMenuItem]()
    var pickerView : UIPickerView
    var textField : UITextField
    var selectedItem : EpaVehicleMenuItem?
    var lastSelectedIndex : Int = -1
    private var childComponents = [VehiclePickerDelegate]()
    
    var selectedValue : String? {
        get {
            return selectedItem?.value
        }
    }
   
    init(pickerView: UIPickerView, textField: UITextField) {
        
        self.pickerView = pickerView
        self.textField = textField
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return data[row].text
    }
    
    // MARK: - Web Service Request
    
    func setDataFromRequest(urlRequest: NSURLRequest, queue: NSOperationQueue) {
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, error) -> Void in
            
            if error == nil {
                var parserDelegate = EpaVehicleMenuParser()
                var parser = NSXMLParser(data: data)
                parser.delegate = parserDelegate
                parser.parse()
                self.data = parserDelegate.values
                self.pickerView.reloadAllComponents()
                println("Response URL= \(response.URL), Data count= \(self.data.count)")
                if data.length > 0 {
                    self.pickerView.selectRow(0, inComponent: 0, animated: false)
                }
            } else {
                println("An error occurred for response url = \(response.URL). Error = \(error)")
            }
        }
    }
    
    func set() {
        
    }
    
    // MARK: - Picker Actions
    
    func done() {
        
        let selectedIndex = pickerView.selectedRowInComponent(0)
        selectedItem = data[selectedIndex]
        textField.text = selectedItem!.text
        textField.resignFirstResponder()
        if selectedIndex != lastSelectedIndex {
            resetChildComponents()
            if selectedIndex > -1 {
                loadChildComponents()
            }
        }
        lastSelectedIndex = selectedIndex
    }
    
    func cancel() {
        
        textField.resignFirstResponder()
        if lastSelectedIndex > -1 {
            pickerView.selectRow(lastSelectedIndex, inComponent: 0, animated: false)
        }
    }
    
    func reset() {
        
        textField.text = nil
        lastSelectedIndex = -1
        selectedItem = nil
        data.removeAll(keepCapacity: false)
        pickerView.reloadAllComponents()
        resetChildComponents()
    }
    
    private func resetChildComponents() {
    
        for childComponent in childComponents {
            childComponent.reset()
        }
    }
    
    private func loadChildComponents() {
        
        for childComponent in childComponents {
            childComponent.load()
        }
    }
    
    func load() {
        // subclasses should override
    }
   
}

///
/// The vehicle Year picker data source and delegate manager.
///
class VehicleYearPickerDelegate: VehiclePickerDelegate {
    
    override func load() {
        
        let url = NSURL(string: "ws/rest/vehicle/menu/year", relativeToURL: baseUrl)
        let urlRequest = NSURLRequest(URL: url!)
        let queue = NSOperationQueue.currentQueue()
        setDataFromRequest(urlRequest, queue: queue!)
    }
}

///
/// The vehicle Make picker data source and delegate manager.
///
class VehicleMakePickerDelegate: VehiclePickerDelegate {
    
    private var _parentComponent: VehicleYearPickerDelegate?
    
    var parentComponent: VehicleYearPickerDelegate? {
        get {
            return _parentComponent
        }
        set {
            _parentComponent = newValue
            if newValue != nil {
                newValue!.childComponents.append(self)
            }
        }
    }
    
    override func load() {
        
        let year = parentComponent?.selectedValue
        
        if year != nil {
            
            let urlString = "ws/rest/vehicle/menu/make?year=\(year!)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let url = NSURL(string: urlString!, relativeToURL: baseUrl)
            let urlRequest = NSURLRequest(URL: url!)
            let queue = NSOperationQueue.currentQueue()
            setDataFromRequest(urlRequest, queue: queue!)
        } else {
            println("Could not load the models because of missing request parameters: year = \(year)")
        }
        
    }
}

///
/// The vehicle Model picker data source and delegate manager.
///
class VehicleModelPickerDelegate: VehiclePickerDelegate {
    
    private var _parentComponent: VehicleMakePickerDelegate?
    
    var parentComponent: VehicleMakePickerDelegate? {
        get {
            return _parentComponent
        }
        set {
            _parentComponent = newValue
            if newValue != nil {
                newValue!.childComponents.append(self)
            }
        }
    }
    
    override func load() {
    
        let make = parentComponent?.selectedValue
        let year = parentComponent?.parentComponent?.selectedValue
        
        if make != nil && year != nil {

            let urlString = "ws/rest/vehicle/menu/model?year=\(year!)&make=\(make!)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let url = NSURL(string: urlString!, relativeToURL: baseUrl)
            let urlRequest = NSURLRequest(URL: url!)
            let queue = NSOperationQueue.currentQueue()
            setDataFromRequest(urlRequest, queue: queue!)
        } else {
            println("Could not load the models because of missing request parameters: year = \(year), make = \(make)")
        }
    }
}

///
/// The vehicle Options picker data source and delegate manager.
///
class VehicleOptionsPickerDelegate: VehiclePickerDelegate {
    
    var vehicle : EpaVehicle?
    
    private var _parentComponent: VehicleModelPickerDelegate?
    
    var parentComponent: VehicleModelPickerDelegate? {
        get {
            return _parentComponent
        }
        set {
            _parentComponent = newValue
            if newValue != nil {
                newValue!.childComponents.append(self)
            }
        }
    }
    
    override func load() {

        let model = parentComponent?.selectedValue
        let make = parentComponent?.parentComponent?.selectedValue
        let year = parentComponent?.parentComponent?.parentComponent?.selectedValue
    
        if model != nil && make != nil && year != nil {
    
            let urlString = "ws/rest/vehicle/menu/options?year=\(year!)&make=\(make!)&model=\(model!)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let url = NSURL(string: urlString!, relativeToURL: baseUrl)
            let urlRequest = NSURLRequest(URL: url!)
            let queue = NSOperationQueue.currentQueue()
            setDataFromRequest(urlRequest, queue: queue!)
        } else {
            println("Could not load the models because of missing request parameters: year = \(year), make = \(make), model=\(model)")
        }
    }
    
    override func reset() {
        
        super.reset()
        
        vehicle = nil
    }
    
    override func done() {
        
        super.done()
        
        if let id = self.selectedItem?.value {
            
            let url = NSURL(string: "ws/rest/vehicle/\(id)", relativeToURL: baseUrl)
            let urlRequest = NSURLRequest(URL: url!)
            let queue = NSOperationQueue.currentQueue()
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, error) -> Void in
                
                if error == nil {
                    var parserDelegate = EpaVehicleParser()
                    var parser = NSXMLParser(data: data)
                    parser.delegate = parserDelegate
                    parser.parse()
                    self.vehicle = parserDelegate.value
                    println("Response URL= \(response.URL), Value = \(self.vehicle)")
                } else {
                    println("An error occurred for response url = \(response.URL). Error = \(error)")
                }
            }
        }
    }
}
