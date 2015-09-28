import UIKit


class CaDistanceUnitTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


class CaDistanceUnitListController: UITableViewController {
    
    // MARK: - Properties
    
    private var selectedRow: Int?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CaDistanceUnitStyle.ViewBgColor
        tableView.registerClass(CaDistanceUnitTableViewCell.self, forCellReuseIdentifier: "Cell")
        reset()
    }

    private func reset() {
        
        selectedRow = nil
        let unit = CaDataManager.instance.defaultDistanceUnit
        for index in 0...(LengthUnit.userValues.count - 1) {
            if LengthUnit.userValues[index] == unit {
                selectedRow = index
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return LengthUnit.userValues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = LengthUnit.userValues[indexPath.row].description
        cell.backgroundColor = CaDistanceUnitStyle.CellBgColor
        cell.textLabel?.font = CaDistanceUnitStyle.CellFont
        if selectedRow == indexPath.row {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if selectedRow != nil {
            let selectedCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedRow!, inSection: 0))
            selectedCell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        selectedRow = indexPath.row
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.None
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if selectedRow != nil {
            let unit = LengthUnit.userValues[selectedRow!]
            CaDataManager.instance.saveDefaultSetting(distanceUnit: unit)
        }
    }
}
