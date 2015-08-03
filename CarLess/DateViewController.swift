import UIKit

class DateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var initialDate: NSDate?
    
    var date: NSDate {
        get {
            return datePicker.date
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let today = (NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!).startOfDayForDate(NSDate())
        datePicker.maximumDate = today
        datePicker.date = initialDate != nil ? initialDate! : today
    }

}
