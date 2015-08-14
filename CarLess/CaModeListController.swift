import UIKit

class CaModeListController: UITableViewController {
    
    private struct Identifier {
        static let ModeCell = "ModeTypeTableCell"
    }
    
    
    var mode: Mode?
    
    private var modes: [Mode] = Mode.allValues
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if mode == nil {
            mode = modes.first
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        var initialModeIndex: Int = indexForMode(mode!)!
        let indexPath = NSIndexPath(forRow: initialModeIndex, inSection: 0)
        tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.Middle)
    }
    
    private func indexForMode(mode: Mode) -> Int? {
        
       for var index = 0; index < modes.count; index++ {
            if modes[index] == mode {
                return index
            }
        }
        return nil
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return modes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Identifier.ModeCell, forIndexPath: indexPath) as! ModesTableViewCell

        cell.mode = modes[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        mode = modes[indexPath.row]
    }
}
