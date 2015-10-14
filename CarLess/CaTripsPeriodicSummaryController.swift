import UIKit

class CaTripsPeriodicSummaryCell: UITableViewCell {
   
    var dateLabel = UILabel()
    var tripsCountLabel = UILabel()
    var moneySavedTotalLabel = UILabel()
    var fuelSavedTotalLabel = UILabel()
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let frameWidth = contentView.frame.size.width - CaStyle.LeftViewPadding - CaStyle.RightViewPadding
        let dateWidth = frameWidth * 0.25
        let tripsWidth = frameWidth * 0.15
        let moneyWidth = frameWidth * 0.3
        let fuelWidth = frameWidth * 0.3
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        
        tripsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tripsCountLabel)
        
        fuelSavedTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fuelSavedTotalLabel)
        
        moneySavedTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(moneySavedTotalLabel)
        
        contentView.addConstraint(NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:  contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: CaStyle.LeftViewPadding))
        contentView.addConstraint(NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: dateWidth))
        
        contentView.addConstraint(NSLayoutConstraint(item: tripsCountLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: dateLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: tripsCountLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: tripsCountLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: tripsWidth))
        
        contentView.addConstraint(NSLayoutConstraint(item: fuelSavedTotalLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: tripsCountLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: fuelSavedTotalLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: fuelSavedTotalLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: fuelWidth))
        
        contentView.addConstraint(NSLayoutConstraint(item: moneySavedTotalLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedTotalLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: moneySavedTotalLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: moneySavedTotalLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: moneyWidth))
        
    }
}


class CaTripsPeriodicSummaryController: UITableViewController {
    
    // MARK: - Properties
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        return formatter
        }()
    
    var data: [CaTripsSummary]!
    var period: SummaryPeriod!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let trips = CaDataManager.instance.fetchTrips()
        var collator = CaTripsSummaryCollator(data: trips, period: period)
        data = collator.collate()
        tableView.registerClass(CaTripsPeriodicSummaryCell.self, forCellReuseIdentifier: "Cell")
        styleView()
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
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if indexPath.row == 0 {
            
            cell.dateLabel.text = period == SummaryPeriod.Monthly ? "Month" : "Week"
            cell.tripsCountLabel.text = "Trips"
            cell.moneySavedTotalLabel.text = "Money Saved"
            cell.fuelSavedTotalLabel.text = "Fuel Saved"
            applyHeaderCellStyle(cell)
        } else {
            
            let summary = data[indexPath.row - 1]
            cell.dateLabel.text = dateFormatter.stringFromDate(summary.startDate)
            cell.tripsCountLabel.text = "\(summary.tripsCount)"
            cell.moneySavedTotalLabel.text = CaFormatter.money.stringFromNumber(summary.moneySavedTotal)
            cell.fuelSavedTotalLabel.text = CaFormatter.distance.stringFromNumber(summary.fuelSavedTotal)
            applyCellStyle(cell)
        }
        
        return cell
    }
    
    // MARK: - Component Styling
    
    private func styleView() {
        
        navigationItem.title = period == SummaryPeriod.Monthly ? "Monthly Summary" : "Weekly Summary"
        view.backgroundColor = CaStyle.ViewBgColor
    }
    
    private func applyHeaderCellStyle(cell: CaTripsPeriodicSummaryCell) {
        
        cell.dateLabel.textColor = CaStyle.CellHeaderColor
        cell.dateLabel.font = CaStyle.CellHeaderFont
        
        cell.tripsCountLabel.textColor = CaStyle.CellHeaderColor
        cell.tripsCountLabel.font = CaStyle.CellHeaderFont
        cell.tripsCountLabel.textAlignment = NSTextAlignment.Right
        
        cell.fuelSavedTotalLabel.textColor = CaStyle.CellHeaderColor
        cell.fuelSavedTotalLabel.font = CaStyle.CellHeaderFont
        cell.fuelSavedTotalLabel.numberOfLines = 0
        cell.fuelSavedTotalLabel.textAlignment = NSTextAlignment.Right
        
        cell.moneySavedTotalLabel.textColor = CaStyle.CellHeaderColor
        cell.moneySavedTotalLabel.font = CaStyle.CellHeaderFont
        cell.moneySavedTotalLabel.numberOfLines = 0
        cell.moneySavedTotalLabel.textAlignment = NSTextAlignment.Right
        
        cell.backgroundColor = CaStyle.CellHeaderBgColor
    }
    
    private func applyCellStyle(cell: CaTripsPeriodicSummaryCell) {
        
        cell.dateLabel.textColor = CaStyle.CellRowColor
        cell.dateLabel.font = CaStyle.CellRowFont
        
        cell.tripsCountLabel.textColor = CaStyle.CellRowColor
        cell.tripsCountLabel.font = CaStyle.CellRowFont
        cell.tripsCountLabel.textAlignment = NSTextAlignment.Right
        
        cell.fuelSavedTotalLabel.textColor = CaStyle.CellRowColor
        cell.fuelSavedTotalLabel.font = CaStyle.CellRowFont
        cell.fuelSavedTotalLabel.textAlignment = NSTextAlignment.Right
        
        cell.moneySavedTotalLabel.textColor = CaStyle.CellRowColor
        cell.moneySavedTotalLabel.font = CaStyle.CellRowFont
        cell.moneySavedTotalLabel.textAlignment = NSTextAlignment.Right
        
        cell.backgroundColor = CaStyle.CellRowBgColor
    }
    
}
