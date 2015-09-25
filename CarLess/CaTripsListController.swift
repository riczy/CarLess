import UIKit

class CaTripTableViewCell: UITableViewCell {
    
    @IBOutlet weak var modeImageView: UIImageView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceUnitLabel: UILabel!
}

class CaTripsListController: UITableViewController {
    
    private static var CellReuseIdentifier = "TripTableViewCell"
    
    private var keyDateFormatter : NSDateFormatter!
    private var headerDateFormatter : NSDateFormatter!
    private var headerWeekDayFormatter : NSDateFormatter!
    private var cellTimeFormatter : NSDateFormatter!
    private var distanceUnit : LengthUnit!
    private var tripsMap : [String : [Trip]]!
    private var tripsMapOrderedKeys : [String]!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        applyStyle()
        
        keyDateFormatter = NSDateFormatter()
        keyDateFormatter.dateFormat = "yyyy-MM-dd"
        
        headerDateFormatter = NSDateFormatter()
        headerDateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        headerWeekDayFormatter = NSDateFormatter()
        headerWeekDayFormatter.dateFormat = "EEEE"
        
        cellTimeFormatter = NSDateFormatter()
        cellTimeFormatter.dateStyle = NSDateFormatterStyle.NoStyle
        cellTimeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    }
    
    override func viewWillAppear(animated: Bool) {
        
        fetchData()
        tableView.reloadData()
    }
    
    private func applyStyle() {
    
        view.backgroundColor = CaTripListStyle.ViewBgColor
    }
    
    private func fetchData() {
        
        distanceUnit  = CaDataManager.instance.getDefaultDistanceUnit()
        
        let tripsArray = CaDataManager.instance.fetchTrips()
        tripsMap = [String : [Trip]]()
        
        for trip in tripsArray {
            
            let dateKey : String = keyDateFormatter.stringFromDate(trip.startTimestamp)
            var tripArrayValue : [Trip]? = tripsMap[dateKey]
            if tripArrayValue == nil {
                tripArrayValue = [trip]
            } else {
                tripArrayValue!.append(trip)
            }
            tripsMap.updateValue(tripArrayValue!, forKey: dateKey)
        }
        
        tripsMapOrderedKeys = tripsMap.keys.sort() {
            $0.compare($1) == NSComparisonResult.OrderedDescending
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return tripsMapOrderedKeys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tripsMap[(tripsMapOrderedKeys[section])]!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CaTripsListController.CellReuseIdentifier, forIndexPath: indexPath) as! CaTripTableViewCell

        let tripArray : [Trip] = tripsMap[(tripsMapOrderedKeys[indexPath.section])]!
        let trip = tripArray[indexPath.row]
        
        applyStyleForCell(cell)
        
        cell.startTimeLabel?.text = cellTimeFormatter.stringFromDate(trip.startTimestamp)
        cell.distanceLabel?.text = CaFormatter.distance.stringFromNumber(trip.getDistanceInUnit(distanceUnit)!)!
        cell.distanceUnitLabel?.text = distanceUnit.abbreviation
        cell.modeImageView?.image = UIImage(named: trip.modeType.imageFilename)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let date = keyDateFormatter.dateFromString(tripsMapOrderedKeys[section])!
        return "\(headerWeekDayFormatter.stringFromDate(date))  \(headerDateFormatter.stringFromDate(date))"
    }
    
    private func applyStyleForCell(cell: CaTripTableViewCell) {
        
        let font = UIFont(name: "Arial Rounded MT Bold", size: 16)
        cell.backgroundColor = CaTripListStyle.CellBgColor
        cell.startTimeLabel.font = font
        cell.distanceLabel.font = font
        cell.distanceUnitLabel.font = font
        cell.startTimeLabel.textColor = CaTripListStyle.CellTimeColor
        cell.distanceUnitLabel.textColor = CaTripListStyle.CellDistanceColor
        cell.distanceLabel.textColor = CaTripListStyle.CellDistanceColor
    }
    
}
