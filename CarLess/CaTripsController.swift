import UIKit

class CaTripTableViewCell: UITableViewCell {
    
    var modeImageView = UIImageView()
    var startTimeLabel = UILabel()
    var distanceLabel = UILabel()
    var distanceUnitLabel = UILabel()
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        modeImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(modeImageView)
        
        startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(startTimeLabel)
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(distanceLabel)
        
        contentView.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: CaStyle.LeftViewPadding))
        contentView.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 20.0))
        contentView.addConstraint(NSLayoutConstraint(item: modeImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 20.0))

        contentView.addConstraint(NSLayoutConstraint(item: startTimeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: modeImageView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 4.0))
        contentView.addConstraint(NSLayoutConstraint(item: startTimeLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: startTimeLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 90.0))
        
        contentView.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: startTimeLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 4.0))
        contentView.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: (CaStyle.RightViewPadding * -1.0)))
        contentView.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        
    }
}


class CaTripsController: UITableViewController {
    
    private var keyDateFormatter : NSDateFormatter!
    private var headerDateFormatter : NSDateFormatter!
    private var headerWeekDayFormatter : NSDateFormatter!
    private var cellTimeFormatter : NSDateFormatter!
    private var distanceFormatter : NSNumberFormatter!
    private var tripsMap : [String : [Trip]]!
    private var tripsMapOrderedKeys : [String]!
    private var selectedIndexPath: NSIndexPath?

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = CaStyle.NavBarBgTintColor
        view.backgroundColor = CaStyle.ViewBgColor
        
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

        distanceFormatter = NSNumberFormatter()
        distanceFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        distanceFormatter.minimum = 0
        distanceFormatter.minimumFractionDigits = 0
        distanceFormatter.maximumFractionDigits = 2
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
            
            let dvc = segue.destinationViewController as! CaTripsPeriodicSummaryController
            dvc.period = selectedIndexPath?.row == 0 ? SummaryPeriod.Weekly : SummaryPeriod.Monthly
            
        //} else if segue.identifier == CaSegue.TripsHomeToTripDetail {
        } else if segue.identifier == CaSegue.TripsHomeToTripSummary {
            
            if selectedIndexPath != nil {
                let dvc = segue.destinationViewController as! CaTripSummaryController
                let trip = tripAtIndexPath(selectedIndexPath!)
                dvc.trip = trip
            }
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
        
        selectedIndexPath = indexPath
        if indexPath.section == 0 {
            performSegueWithIdentifier(CaSegue.TripsHomeToTripPeriodicSummary, sender: self)
        } else {
            //performSegueWithIdentifier(CaSegue.TripsHomeToTripDetail, sender: self)
            performSegueWithIdentifier(CaSegue.TripsHomeToTripSummary, sender: self)
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return indexPath.section != 0
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let section = indexPath.section - 1 // Account for summary reports @ section 0
            let row = indexPath.row
            
            let tripsMapKey = tripsMapOrderedKeys[section]
            var tripsMapValue = tripsMap[tripsMapKey]
            let trip = tripsMapValue?[row]
            do {
                try CaDataManager.instance.delete(trip: trip)
                tripsMapValue?.removeAtIndex(row)
                if tripsMapValue?.count == 0 {
                    tripsMap.removeValueForKey(tripsMapKey)
                    tripsMapOrderedKeys.removeAtIndex(section)
                    tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
                } else {
                    tripsMap[tripsMapKey] = tripsMapValue
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
            } catch {
                NSLog("Error when deleting indexPath = \(indexPath), trip = \(trip)")
            }
        } else {
            NSLog("Unhandled editing style \(editingStyle)")
        }
    }
    
    private func tableViewSummaryCell(indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath)
        cell.textLabel?.text = indexPath.row == 0 ? "Weekly summary" : "Monthly summary"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.textColor = CaStyle.CellLabelColor
        cell.textLabel?.font = CaStyle.CellLabelFont
        return cell
    }
    
    private func tableViewTripCell(indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TripCell", forIndexPath: indexPath) as! CaTripTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let trip = tripAtIndexPath(indexPath)
        let distanceUnit = CaDataManager.instance.defaultDistanceUnit
        
        cell.startTimeLabel.text = cellTimeFormatter.stringFromDate(trip.startTimestamp)
        cell.distanceLabel.text = "\(distanceFormatter.stringFromNumber(trip.distanceInUnit(distanceUnit))!) \(distanceUnit.abbreviation)"
        cell.modeImageView.image = UIImage(named: trip.modeType.imageFilename)

        cell.startTimeLabel.font = CaStyle.CellRowFont
        cell.startTimeLabel.textColor = CaStyle.CellRowColor
        cell.startTimeLabel.textAlignment = NSTextAlignment.Right
        cell.distanceLabel.font = CaStyle.CellRowFont
        cell.distanceLabel.textColor = CaStyle.CellRowColor
        cell.distanceLabel.textAlignment = NSTextAlignment.Right
        cell.backgroundColor = CaStyle.CellRowBgColor
        cell.selectionStyle = UITableViewCellSelectionStyle.Default

        return cell
    }
    
    private func tripAtIndexPath(indexPath: NSIndexPath) -> Trip {
        
        let section = indexPath.section - 1
        let row = indexPath.row
        
        let tripArray: [Trip] = tripsMap[(tripsMapOrderedKeys[section])]!
        return tripArray[row]
    }
}
