import UIKit


class CaSettingsTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class CaSettingsController: UITableViewController {
    
    // MARK: - UI Properties
    
    private var vehicleLabel: UILabel!
    private var distanceUnitLabel: UILabel!
    private var distanceUnitPicker: UIPickerView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        styleView()
        tableView.registerClass(CaSettingsTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - Navigation
    
    @IBAction
    func returnToSettingsMain(segue: UIStoryboardSegue) {
        
        if segue.identifier == CaSegue.VehicleToSettings {
            let svc = segue.sourceViewController as! CaVehicleController
            vehicleLabel.text = svc.vehicle?.displayDescription
        } else if segue.identifier == CaSegue.DistanceUnitToSettings {
            distanceUnitLabel.text = CaDataManager.instance.defaultDistanceUnit.description
        }
    }

    // MARK: - Table Delegation
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Preferences
        if section == 0 {
            return 2
            // About
        } else if section == 1 {
            return 1
        }
        
        NSLog("Returning 0 number of rows for section that was not defined. Section = \(section)")
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        // Preferences
        if section == 0 {
            if row == 0 {
                return buildDistanceUnitPreferenceCell(indexPath)
            } else if row == 1 {
                return buildVehiclePreferenceCell(indexPath)
            }
        // About
        } else if section == 1 {
            if row == 0 {
                return buildVersionCell(indexPath)
            }
        }
        
        NSLog("Building table cell that was not defined. Section = \(section), Row = \(row)")
        return buildMissingCell(indexPath)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Preferences"
        } else if section == 1 {
            return "About"
        }
        
        NSLog("Building section title that was not defined. Section = \(section)")
        return "Missing Title for Section \(section)"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let section = indexPath.section
        let row = indexPath.row

        if section == 0 {
            // Distance Unit
            if row == 0 {
                performSegueWithIdentifier(CaSegue.SettingsToDistanceUnit, sender: self)
            // Vehicle
            } else if row == 1 {
                performSegueWithIdentifier(CaSegue.SettingsToVehicle, sender: self)
            }
        }
    }
        
    // MARK: - Table Cell Construction
    
    private func buildDistanceUnitPreferenceCell(indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = "Distance Unit"
        cell.detailTextLabel?.text = CaDataManager.instance.defaultDistanceUnit.rawValue
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        applyStyleForCell(cell)
        
        distanceUnitLabel = cell.detailTextLabel!
        
        return cell
    }
    
    private func buildVehiclePreferenceCell(indexPath: NSIndexPath) -> UITableViewCell {
        
        let vehicle = CaDataManager.instance.defaultVehicle
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = "Vehicle"
        cell.detailTextLabel?.text = vehicle?.displayDescription
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        applyStyleForCell(cell)
        
        vehicleLabel = cell.detailTextLabel!
        
        return cell
    }
    
    private func buildVersionCell(indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = "Version"
        cell.detailTextLabel?.text = "0.8 15NOV23-1351"
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        applyStyleForCell(cell)
        return cell
    }
    
    private func buildMissingCell(indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(indexPath.section) - \(indexPath.row)"
        cell.detailTextLabel?.text = "Missing cell setup"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    // MARK: - Style
    
    private func styleView() {
        
        navigationController?.navigationBar.barTintColor = CaStyle.NavBarBgTintColor
        navigationController?.navigationBar.tintColor = CaStyle.NavBarTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CaStyle.NavBarTitleColor]
        view.backgroundColor = CaStyle.ViewBgColor
    }
    
    private func applyStyleForCell(cell: UITableViewCell) {
        
        cell.backgroundColor = CaStyle.CellBgColor
        
        cell.textLabel?.font = CaStyle.CellLabelFont
        cell.textLabel?.textColor = CaStyle.CellLabelColor
        
        cell.detailTextLabel?.font = CaStyle.CellValueFont
        cell.detailTextLabel?.textColor = CaStyle.CellValueColor
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.minimumScaleFactor = CaStyle.CellValueFontMinimumScaleFactor
    }

}


