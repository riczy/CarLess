import UIKit

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
    
    private var _childComponent: VehiclePickerDelegate?
    var childComponent: VehiclePickerDelegate? {
        get {
            return _childComponent
        }
    }
    
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].text
    }
    
    // MARK: - Web Service Request
    
    func setDataFromRequest(urlRequest: NSURLRequest, onSuccess: (() -> Void)?) {
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error == nil && data != nil {
                let parserDelegate = EpaVehicleMenuParser()
                let parser = NSXMLParser(data: data!)
                parser.delegate = parserDelegate
                parser.parse()
                self.data = parserDelegate.values
                self.pickerView.reloadAllComponents()
                print("Response URL= \(response?.URL), Data count= \(self.data.count)")
                if data!.length > 0 {
                    self.textField.enabled = true
                    self.pickerView.selectRow(0, inComponent: 0, animated: false)
                }
                onSuccess?()
            } else {
                print("Response url = \(response?.URL). Error = \(error). Data = \(data)")
            }
        }
    }
    
    // MARK: - Picker Actions
    
    func done() {
        
        let selectedIndex = pickerView.selectedRowInComponent(0)
        if selectedIndex >= 0 && selectedIndex < data.count {
            selectedItem = data[selectedIndex]
            textField.text = selectedItem!.text
            if selectedIndex != lastSelectedIndex {
                childComponent?.reset()
                if selectedIndex > -1 {
                    childComponent?.load()
                }
            }
            lastSelectedIndex = selectedIndex
        }
        textField.resignFirstResponder()
    }
    
    func cancel() {
        
        textField.resignFirstResponder()
        if lastSelectedIndex > -1 {
            pickerView.selectRow(lastSelectedIndex, inComponent: 0, animated: false)
        }
    }
    
    // MARK: - Miscellaneous
    
    func reset() {
        
        textField.text = nil
        textField.enabled = false
        lastSelectedIndex = -1
        selectedItem = nil
        data.removeAll(keepCapacity: false)
        pickerView.reloadAllComponents()
        childComponent?.reset()
    }
    
    /// Sets the text field, picker, and selected item with the data array item
    /// that has a value matching the given value. It is expected that the data
    /// array is already fetched and loaded appropriately. In most cases, this
    /// method will be the success handler of the `setDataFromRequest:onSuccess:`
    /// method when loading data.
    ///
    /// Returns true if a match was found and false if not.
    private func set(fromValue value: String) -> Bool {
        
        for index in 0...data.count-1 {
            let item = data[index]
            if item.value == value {
                textField.text = item.text
                selectedItem = item
                lastSelectedIndex = index
                pickerView.selectRow(index, inComponent: 0, animated: false)
                return true
            }
        }
        return false
    }
    
    /// Subclasses will override.
    ///
    ///
    func load() {
    }
    
}

///
/// The vehicle Year picker data source and delegate manager.
///
class VehicleYearPickerDelegate: VehiclePickerDelegate {
    
    override func load() {
        load(selectYear: nil)
    }
    
    func load(selectYear year: String?) {
        
        let url = NSURL(string: "ws/rest/vehicle/menu/year", relativeToURL: baseUrl)
        let urlRequest = NSURLRequest(URL: url!)
        var onSuccess: (() -> Void)?
        if year != nil {
            onSuccess = {() -> Void in
                self.set(fromValue: year!)
            }
        }
        setDataFromRequest(urlRequest, onSuccess: onSuccess)
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
                newValue!._childComponent = self
            }
        }
    }
    
    override func load() {
        
        let year = parentComponent?.selectedValue
        if year != nil {
            self.load(year: year!, selectMake: nil)
        } else {
            NSLog("Could not load the makes because of missing request parameters: year = \(year)")
        }
    }
    
    func load(year year: String, selectMake make: String?) {
        
        let queryString = "year=\(year)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: "ws/rest/vehicle/menu/make?\(queryString!)", relativeToURL: baseUrl)
        let urlRequest = NSURLRequest(URL: url!)
        var onSuccess: (() -> Void)?
        if make != nil {
            onSuccess = {() -> Void in
                self.set(fromValue: make!)
            }
        }
        setDataFromRequest(urlRequest, onSuccess: onSuccess)
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
                newValue!._childComponent = self
            }
        }
    }
    
    override func load() {
        
        let make = parentComponent?.selectedValue
        let year = parentComponent?.parentComponent?.selectedValue
        
        if make != nil && year != nil {
            self.load(year: year!, make: make!, selectModel: nil)
        } else {
            print("Could not load the models because of missing request parameters: year = \(year), make = \(make)")
        }
    }
    
    func load(year year: String, make: String, selectModel model: String?) {
        
        let queryString = "year=\(year)&make=\(make)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: "ws/rest/vehicle/menu/model?\(queryString!)", relativeToURL: baseUrl)
        let urlRequest = NSURLRequest(URL: url!)
        var onSuccess: (() -> Void)?
        if model != nil {
            onSuccess = {() -> Void in
                self.set(fromValue: model!)
            }
        }
        setDataFromRequest(urlRequest, onSuccess: onSuccess)
    }
}

///
/// The vehicle Options picker data source and delegate manager.
///
class VehicleOptionsPickerDelegate: VehiclePickerDelegate {
    
    private var _vehicle : EpaVehicle?
    var vehicle : EpaVehicle? {
        get {
            return _vehicle
        }
        set {
            _vehicle = newValue
            viewController.setMpgDisplayForVehicle(_vehicle)
        }
    }
    
    private var viewController : CaVehicleController!
    
    private var _parentComponent: VehicleModelPickerDelegate?
    
    var parentComponent: VehicleModelPickerDelegate? {
        get {
            return _parentComponent
        }
        set {
            _parentComponent = newValue
            if newValue != nil {
                newValue!._childComponent = self
            }
        }
    }

    init(pickerView: UIPickerView, textField: UITextField, viewController: CaVehicleController) {
        
        super.init(pickerView: pickerView, textField: textField)
        self.viewController = viewController
    }
    
    
    override func load() {
        
        let model = parentComponent?.selectedValue
        let make = parentComponent?.parentComponent?.selectedValue
        let year = parentComponent?.parentComponent?.parentComponent?.selectedValue
        
        if model != nil && make != nil && year != nil {
            load(year: year!, make: make!, model: model!, selectOption: nil)
        } else {
            print("Could not load the options because of missing request parameters: year = \(year), make = \(make), model=\(model)")
        }
    }
    
    func load(year year: String, make: String, model: String, selectOption option: String?) {
        
        let queryString = "year=\(year)&make=\(make)&model=\(model)".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        let url = NSURL(string: "ws/rest/vehicle/menu/options?\(queryString!)", relativeToURL: baseUrl)
        let urlRequest = NSURLRequest(URL: url!)
        var onSuccess: (() -> Void)?
        if option != nil {
            onSuccess = {() -> Void in
                self.set(fromValue: option!)
            }
        }
        setDataFromRequest(urlRequest, onSuccess: onSuccess)
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
            
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
                
                if error == nil && data != nil {
                    let parserDelegate = EpaVehicleParser()
                    let parser = NSXMLParser(data: data!)
                    parser.delegate = parserDelegate
                    parser.parse()
                    self.vehicle = parserDelegate.value
                    print("Response URL= \(response?.URL), Value = \(self.vehicle)")
                } else {
                    print("Response url = \(response?.URL). Error = \(error). Data = \(data)")
                }
            }
        }
    }
}
