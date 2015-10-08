import UIKit

class CaTripsMonthlySummaryTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class CaTripsController: UITableViewController {
    
    private var selectedSummaryPeriod: SummaryPeriod?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CaTripStyle.ViewBgColor
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == CaSegue.TripsHomeToTripPeriodicSummary {
            
            let nvc = segue.destinationViewController as! UINavigationController
            let dvc = nvc.topViewController as! CaTripsPeriodicSummaryController
            dvc.period = selectedSummaryPeriod == nil ? SummaryPeriod.Monthly : selectedSummaryPeriod
            selectedSummaryPeriod = nil
        }
    }
    
    @IBAction
    func returnToTripsHome(segue: UIStoryboardSegue) {
        // do nothing
    }

    // MARK: - Table Delegation
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if section == 0 {
            if row == 0 {
                cell.textLabel?.text = "Trips"
            }
        } else if section == 1 {
            if row == 0 {
                cell.textLabel?.text = "Weekly"
            } else if row == 1 {
                cell.textLabel?.text = "Monthly"
            }
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor = CaTripStyle.CellBgColor
        cell.textLabel?.textColor = CaTripStyle.CellTitleColor
        cell.textLabel?.font = CaTripStyle.CellTitleFont
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Trips"
        } else if section == 1 {
            return "Summary"
        }
        return ""
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            // Trip List
            if row == 0 {
                performSegueWithIdentifier(CaSegue.TripsHomeToTripList, sender: self)
            }
        } else if section == 1 {
            // Weekly Summary
            if row == 0 {
                selectedSummaryPeriod = SummaryPeriod.Weekly
            // Monthly Summary
            } else if row == 1 {
                selectedSummaryPeriod = SummaryPeriod.Monthly
            }
            performSegueWithIdentifier(CaSegue.TripsHomeToTripPeriodicSummary, sender: self)
        }
    }
}
