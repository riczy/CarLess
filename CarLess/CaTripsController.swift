import UIKit

class CaTripTableViewCell: UITableViewCell {
    
    var modeImageView: UIImageView!
    var startTimeLabel: UILabel!
    var distanceLabel: UILabel!
    var distanceUnitLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        modeImageView = UIImageView()
        modeImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(modeImageView)
        
        startTimeLabel = UILabel()
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(startTimeLabel)
        
        distanceLabel = UILabel()
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(distanceLabel)
        
        contentView.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.LeftMargin, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterYWithinMargins, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 20.0))
        contentView.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 20.0))

        contentView.addConstraint(NSLayoutConstraint(item: startTimeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: modeImageView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 4.0))
        contentView.addConstraint(NSLayoutConstraint(item: startTimeLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterYWithinMargins, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: startTimeLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 90.0))
        
        contentView.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: startTimeLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 4.0))
        contentView.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.RightMargin, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterYWithinMargins, multiplier: 1.0, constant: 0.0))
        
    }
}


class CaTripsController: UITableViewController {
    
    private var keyDateFormatter : NSDateFormatter!
    private var headerDateFormatter : NSDateFormatter!
    private var headerWeekDayFormatter : NSDateFormatter!
    private var cellTimeFormatter : NSDateFormatter!
    private var tripsMap : [String : [Trip]]!
    private var tripsMapOrderedKeys : [String]!
    private var selectedSummaryPeriod: SummaryPeriod?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = CaTripStyle.ViewBgColor
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SummaryCell")
        tableView.registerClass(CaTripTableViewCell.self, forCellReuseIdentifier: "TripCell")
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func fetchData() {
        
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
        
        return tripsMapOrderedKeys.count + 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }
        return tripsMap[(tripsMapOrderedKeys[section - 1])]!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            return tableViewSummaryCell(indexPath)
        }
        
        return tableViewTripCell(indexPath)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return nil
        }
        let date = keyDateFormatter.dateFromString(tripsMapOrderedKeys[section - 1])!
        return "\(headerWeekDayFormatter.stringFromDate(date))  \(headerDateFormatter.stringFromDate(date))"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            selectedSummaryPeriod = indexPath.row == 0 ? SummaryPeriod.Weekly : SummaryPeriod.Monthly
            performSegueWithIdentifier(CaSegue.TripsHomeToTripPeriodicSummary, sender: self)
        }
    }
    
    private func tableViewSummaryCell(indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath)
        cell.textLabel?.text = indexPath.row == 0 ? "Weekly Summary" : "Monthly Summary"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor = CaTripStyle.SummaryCellBgColor
        cell.textLabel?.textColor = CaTripStyle.SummaryCellColor
        cell.textLabel?.font = CaTripStyle.SummaryCellFont
        return cell
    }
    
    private func tableViewTripCell(indexPath: NSIndexPath) -> UITableViewCell {
        
        let section = indexPath.section - 1
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TripCell", forIndexPath: indexPath) as! CaTripTableViewCell
        
        let tripArray : [Trip] = tripsMap[(tripsMapOrderedKeys[section])]!
        let trip = tripArray[row]
        let distanceUnit = CaDataManager.instance.defaultDistanceUnit
        
        cell.startTimeLabel?.text = cellTimeFormatter.stringFromDate(trip.startTimestamp)
        cell.distanceLabel?.text = "\(CaFormatter.distance.stringFromNumber(trip.getDistanceInUnit(distanceUnit))!) \(distanceUnit.abbreviation)"
        cell.modeImageView?.image = UIImage(named: trip.modeType.imageFilename)

        cell.startTimeLabel.font = CaTripListStyle.CellFont
        cell.startTimeLabel.textColor = CaTripListStyle.CellTimeColor
        cell.startTimeLabel.textAlignment = NSTextAlignment.Right
        cell.distanceLabel.font = CaTripListStyle.CellFont
        cell.distanceLabel.textColor = CaTripListStyle.CellDistanceColor
        cell.distanceLabel.textAlignment = NSTextAlignment.Right
        cell.backgroundColor = CaTripListStyle.CellBgColor

        return cell
    }
}
