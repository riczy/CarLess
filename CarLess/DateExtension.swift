import Foundation

extension NSDate {
    
    public func isBefore(date: NSDate) -> Bool {
    
        return self.compare(date) == .OrderedAscending
    }
    
    public func isAfter(date: NSDate) -> Bool {
    
        return self.compare(date) == .OrderedDescending
    }
}
