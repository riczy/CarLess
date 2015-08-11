import UIKit

class LogTableViewController: UITableViewController {
    
    private struct Storyboard {
        
        static let TripDateSegue = "TripDateSegue"
        static let TripModeSegue = "TripModeSegue"
        static let TripRouteSegue = "TripRouteSegue"
    }
    
    private var trip = Trip()
    
    private var dateFormatter: NSDateFormatter!
    
    @IBOutlet weak var tripDateLabel: UILabel!
    @IBOutlet weak var tripModeLabel: UILabel!
    @IBOutlet weak var tripRouteLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func save(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        
        tripDateLabel.text! = dateFormatter.stringFromDate(trip.date)
        tripModeLabel.text! = trip.mode.description
        tripRouteLabel.text! = trip.route.toString()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }
    
    // MARK: - Child Scene Actions
    
    @IBAction
    func cancel(segue: UIStoryboardSegue) {
        // do nothing
    }
    
    @IBAction
    func saveModeSelection(segue: UIStoryboardSegue) {
        
        let modesVc: ModesTableViewController = segue.sourceViewController as! ModesTableViewController
        trip.mode = modesVc.mode!
        tripModeLabel.text = modesVc.mode!.description
    }
    
    @IBAction
    func saveDateSelection(segue: UIStoryboardSegue) {
        
        let dateVc: DateViewController = segue.sourceViewController as! DateViewController
        trip.date = dateVc.date
        tripDateLabel.text = dateFormatter.stringFromDate(dateVc.date)
    }
    
    @IBAction
    func saveRouteEntry(segue: UIStoryboardSegue) {
        
        let vc: ManualRouteController = segue.sourceViewController as! ManualRouteController
        trip.route = vc.route
        tripRouteLabel.text = trip.route.toString()
    }

     // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let segueId = segue.identifier!
        let dvc: AnyObject = segue.destinationViewController
        if segueId == Storyboard.TripDateSegue {
            let dateVc = dvc.topViewController as! DateViewController
            dateVc.initialDate = trip.date
        } else if segueId == Storyboard.TripModeSegue {
            let modesVc = dvc.topViewController as! ModesTableViewController
            modesVc.mode = trip.mode
        } else if segueId == Storyboard.TripRouteSegue {
            let routeVc = dvc.topViewController as! ManualRouteController
            routeVc.route = trip.route
        }
    }

}
