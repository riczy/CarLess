import UIKit

class CaSettingsController: UITableViewController {

    @IBOutlet weak var vehiclesCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CaSettingsStyle.ViewBgColor
        
    }
    
    @IBAction
    func returnToSettingsMain(segue: UIStoryboardSegue) {
        // do nothing
    }
    
    // MARK: - Table view data source
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        
//        return 2
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return 2
//    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier(CaTripsListController.CellReuseIdentifier, forIndexPath: indexPath) as! CaTripTableViewCell
//        
//        let tripArray : [Trip] = tripsMap[(tripsMapOrderedKeys[indexPath.section])]!
//        let trip = tripArray[indexPath.row]
//        
//        applyStyleForCell(cell)
//        
//        cell.startTimeLabel?.text = cellTimeFormatter.stringFromDate(trip.startTimestamp)
//        cell.distanceLabel?.text = CaFormatter.distance.stringFromNumber(trip.getDistanceInUnit(distanceUnit)!)!
//        cell.distanceUnitLabel?.text = distanceUnit.abbreviation
//        cell.modeImageView?.image = UIImage(named: trip.modeType.imageFilename)
//        
//        return cell
//    }
    
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//        return section == 0 ? "Preferences" : "About"
//    }
    
}

