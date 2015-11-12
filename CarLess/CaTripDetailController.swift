import UIKit

class CaTripWaypointCell: UITableViewCell {
    
    @IBOutlet weak var waypointLabel: UILabel!
}

class CaTripDetailController: UITableViewController {

    var trip: Trip?
    private var waypoints: [Waypoint] = [Waypoint]()
    private var dateFormatter: NSDateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        
        let timestampDescriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        waypoints = trip?.waypoints.sortedArrayUsingDescriptors([timestampDescriptor]) as! [Waypoint]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waypoints.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let waypoint = waypoints[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("WaypointCell") as! CaTripWaypointCell
        cell.waypointLabel.text = "row = \(indexPath.row) : timestamp = \(dateFormatter.stringFromDate(waypoint.timestamp)) : \(waypoint)"
        return cell
    }
}
