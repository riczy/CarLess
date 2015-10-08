import UIKit

class CaTripsPeriodicSummaryCell: UITableViewCell {
   
    var dateLabel: UILabel!
    var tripsCountLabel: UILabel!
    var moneySavedTotalLabel: UILabel!
    var fuelSavedTotalLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        
        tripsCountLabel = UILabel()
        tripsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        tripsCountLabel.textAlignment = NSTextAlignment.Right
        contentView.addSubview(tripsCountLabel)
        
        fuelSavedTotalLabel = UILabel()
        fuelSavedTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        fuelSavedTotalLabel.textAlignment = NSTextAlignment.Right
        contentView.addSubview(fuelSavedTotalLabel)
        
        moneySavedTotalLabel = UILabel()
        moneySavedTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        moneySavedTotalLabel.textAlignment = NSTextAlignment.Right
        contentView.addSubview(moneySavedTotalLabel)
        
        let size = contentView.frame.size
        let width = size.width / 4
        
        contentView.addConstraint(NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:  contentView, attribute: NSLayoutAttribute.LeftMargin, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterYWithinMargins, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width))

        contentView.addConstraint(NSLayoutConstraint(item: tripsCountLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: dateLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: tripsCountLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterYWithinMargins, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: tripsCountLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width))
        
        contentView.addConstraint(NSLayoutConstraint(item: fuelSavedTotalLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: tripsCountLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: fuelSavedTotalLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterYWithinMargins, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: fuelSavedTotalLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width))
        
        contentView.addConstraint(NSLayoutConstraint(item: moneySavedTotalLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedTotalLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: moneySavedTotalLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterYWithinMargins, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: moneySavedTotalLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: width))
        
    }
}


class CaTripsPeriodicSummaryController: UITableViewController {
    
    var data: [CaTripsSummary]!
    var period: SummaryPeriod!

    override func viewDidLoad() {

        super.viewDidLoad()
        
        let trips = CaDataManager.instance.fetchTrips()
        var collator = CaTripsSummaryCollator(data: trips, period: period)
        data = collator.collate()
        tableView.registerClass(CaTripsPeriodicSummaryCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.title = period == SummaryPeriod.Monthly ? "Monthly Summary" : "Weekly Summary"
   }

    // MARK: - Table View Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return data.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CaTripsPeriodicSummaryCell
        if indexPath.row == 0 {
            
            cell.dateLabel.text = "Week"
            cell.tripsCountLabel.text = "Trips"
            cell.moneySavedTotalLabel.text = "$"
            cell.fuelSavedTotalLabel.text = "Gallons"
        } else {
            
            let summary = data[indexPath.row - 1]
            cell.dateLabel.text = CaFormatter.date.stringFromDate(summary.startDate)
            cell.tripsCountLabel.text = "\(summary.tripsCount)"
            cell.moneySavedTotalLabel.text = CaFormatter.money.stringFromNumber(summary.moneySavedTotal)
            cell.fuelSavedTotalLabel.text = CaFormatter.distance.stringFromNumber(summary.fuelSavedTotal)
        }
//        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//        applyStyleForCell(cell)
        
        return cell
    }
    
}
