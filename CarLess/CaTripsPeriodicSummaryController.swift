import UIKit

class CaTripsPeriodicSummaryCell: UITableViewCell {
   
    var co2SavedTotalLabel = UILabel()
    var dateLabel = UILabel()
    var distanceLabel = UILabel()
    var fuelSavedTotalLabel = UILabel()
    var moneySavedTotalLabel = UILabel()
    var tripsCountLabel = UILabel()
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let frameWidth = contentView.frame.size.width - CaStyle.LeftViewPadding - CaStyle.RightViewPadding
        let dateWidth = frameWidth * 0.15
        let tripsWidth = frameWidth * 0.1
        let moneyWidth = frameWidth * 0.2
        let fuelWidth = frameWidth * 0.15
        let distanceWidth = frameWidth * 0.2
        let co2Width = frameWidth * 0.2
        
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)
        contentView.addConstraint(NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem:  contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: CaStyle.LeftViewPadding))
        contentView.addConstraint(NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: dateLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: dateWidth))
        
        tripsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tripsCountLabel)
        contentView.addConstraint(NSLayoutConstraint(item: tripsCountLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: dateLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: tripsCountLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: tripsCountLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: tripsWidth))
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(distanceLabel)
        contentView.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: tripsCountLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: distanceWidth))
        
        moneySavedTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(moneySavedTotalLabel)
        contentView.addConstraint(NSLayoutConstraint(item: moneySavedTotalLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: distanceLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: moneySavedTotalLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: moneySavedTotalLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: moneyWidth))
        
        fuelSavedTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(fuelSavedTotalLabel)
        contentView.addConstraint(NSLayoutConstraint(item: fuelSavedTotalLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: moneySavedTotalLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: fuelSavedTotalLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: fuelSavedTotalLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: fuelWidth))
        
        co2SavedTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(co2SavedTotalLabel)
        contentView.addConstraint(NSLayoutConstraint(item: co2SavedTotalLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedTotalLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: co2SavedTotalLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))
        contentView.addConstraint(NSLayoutConstraint(item: co2SavedTotalLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: co2Width))
        
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
    
    var dataTotals: CaTripsSummary!
    var data: [CaTripsSummary]!
    var period: SummaryPeriod!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let trips = CaDataManager.instance.fetchTrips()
        var collator = CaTripsSummaryCollator(data: trips, period: period)
        let collatorResults = collator.collate()
        data = collatorResults.0
        dataTotals = collatorResults.1
        tableView.registerClass(CaTripsPeriodicSummaryCell.self, forCellReuseIdentifier: "Cell")
        styleView()
   }

    // MARK: - Table View Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // data + header + grand totals
        return data.count + 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! CaTripsPeriodicSummaryCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if indexPath.row == 0 {
            cell.dateLabel.text = period == SummaryPeriod.Monthly ? "Month" : "Week"
            cell.tripsCountLabel.text = "Trips"
            cell.moneySavedTotalLabel.text = "Money\n(\(CaFormatter.money.currencySymbol))"
            cell.fuelSavedTotalLabel.text = "Fuel\n(gal)"
            cell.distanceLabel.text = "Distance\n(\(CaDataManager.instance.defaultDistanceUnit.abbreviation))"
            cell.co2SavedTotalLabel.text = "CO\u{2082}\n(lb)"
            applyHeaderCellStyle(cell)
        } else if indexPath.row == 1 {
            cell.dateLabel.text = ""
            cell.tripsCountLabel.text = "\(dataTotals.tripsCount)"
            cell.moneySavedTotalLabel.text = CaFormatter.money.stringFromNumber(dataTotals.moneySavedTotal)
            cell.fuelSavedTotalLabel.text = CaFormatter.decimalDisplay.stringFromNumber(dataTotals.fuelSavedTotal)
            cell.distanceLabel.text = CaFormatter.decimalDisplay.stringFromNumber(dataTotals.distanceInUnit(CaDataManager.instance.defaultDistanceUnit))
            cell.co2SavedTotalLabel.text = CaFormatter.decimalDisplay.stringFromNumber(dataTotals.co2SavedTotal)
            applyTotalsCellStyle(cell)
        } else {
            let summary = data[indexPath.row - 2]
            cell.dateLabel.text = dateFormatter.stringFromDate(summary.startDate)
            cell.tripsCountLabel.text = "\(summary.tripsCount)"
            cell.moneySavedTotalLabel.text = CaFormatter.money.stringFromNumber(summary.moneySavedTotal)
            cell.fuelSavedTotalLabel.text = CaFormatter.decimalDisplay.stringFromNumber(summary.fuelSavedTotal)
            cell.distanceLabel.text = CaFormatter.decimalDisplay.stringFromNumber(summary.distanceInUnit(CaDataManager.instance.defaultDistanceUnit))
            cell.co2SavedTotalLabel.text = CaFormatter.decimalDisplay.stringFromNumber(summary.co2SavedTotal)
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
        
        cell.co2SavedTotalLabel.textColor = CaStyle.CellHeaderColor
        cell.co2SavedTotalLabel.font = CaStyle.CellHeaderFont
        cell.co2SavedTotalLabel.numberOfLines = 0
        cell.co2SavedTotalLabel.textAlignment = NSTextAlignment.Right
        
        cell.distanceLabel.textColor = CaStyle.CellHeaderColor
        cell.distanceLabel.font = CaStyle.CellHeaderFont
        cell.distanceLabel.numberOfLines = 0
        cell.distanceLabel.textAlignment = NSTextAlignment.Right
        
        cell.backgroundColor = CaStyle.CellHeaderBgColor
    }
    
    private func applyTotalsCellStyle(cell: CaTripsPeriodicSummaryCell) {
        
        cell.dateLabel.textColor = CaStyle.CellTripsTotalsRowColor
        cell.dateLabel.font = CaStyle.CellTripsTotalsRowFont
        
        cell.tripsCountLabel.textColor = CaStyle.CellTripsTotalsRowColor
        cell.tripsCountLabel.font = CaStyle.CellTripsTotalsRowFont
        cell.tripsCountLabel.textAlignment = NSTextAlignment.Right
        
        cell.fuelSavedTotalLabel.textColor = CaStyle.CellTripsTotalsRowColor
        cell.fuelSavedTotalLabel.font = CaStyle.CellTripsTotalsRowFont
        cell.fuelSavedTotalLabel.textAlignment = NSTextAlignment.Right
        
        cell.moneySavedTotalLabel.textColor = CaStyle.CellTripsTotalsRowColor
        cell.moneySavedTotalLabel.font = CaStyle.CellTripsTotalsRowFont
        cell.moneySavedTotalLabel.textAlignment = NSTextAlignment.Right
        
        cell.co2SavedTotalLabel.textColor = CaStyle.CellTripsTotalsRowColor
        cell.co2SavedTotalLabel.font = CaStyle.CellTripsTotalsRowFont
        cell.co2SavedTotalLabel.textAlignment = NSTextAlignment.Right
        
        cell.distanceLabel.textColor = CaStyle.CellTripsTotalsRowColor
        cell.distanceLabel.font = CaStyle.CellTripsTotalsRowFont
        cell.distanceLabel.textAlignment = NSTextAlignment.Right
     
        cell.backgroundColor = CaStyle.CellTripsTotalsRowBgColor
    }

    private func applyCellStyle(cell: CaTripsPeriodicSummaryCell) {
        
        cell.dateLabel.textColor = CaStyle.CellRowColor
        cell.dateLabel.font = CaStyle.CellTripsRowFont
        
        cell.tripsCountLabel.textColor = CaStyle.CellRowColor
        cell.tripsCountLabel.font = CaStyle.CellTripsRowFont
        cell.tripsCountLabel.textAlignment = NSTextAlignment.Right
        
        cell.fuelSavedTotalLabel.textColor = CaStyle.CellRowColor
        cell.fuelSavedTotalLabel.font = CaStyle.CellTripsRowFont
        cell.fuelSavedTotalLabel.textAlignment = NSTextAlignment.Right
        
        cell.moneySavedTotalLabel.textColor = CaStyle.CellRowColor
        cell.moneySavedTotalLabel.font = CaStyle.CellTripsRowFont
        cell.moneySavedTotalLabel.textAlignment = NSTextAlignment.Right
        
        cell.co2SavedTotalLabel.textColor = CaStyle.CellRowColor
        cell.co2SavedTotalLabel.font = CaStyle.CellTripsRowFont
        cell.co2SavedTotalLabel.textAlignment = NSTextAlignment.Right
        
        cell.distanceLabel.textColor = CaStyle.CellRowColor
        cell.distanceLabel.font = CaStyle.CellTripsRowFont
        cell.distanceLabel.textAlignment = NSTextAlignment.Right
        
        cell.backgroundColor = CaStyle.CellRowBgColor
    }
    
}
