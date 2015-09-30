import Foundation

extension NSDate {
    
    public func isBefore(date: NSDate) -> Bool {
    
        return self.compare(date) == .OrderedAscending
    }
    
    public func isOnOrBefore(date: NSDate) -> Bool {
        
        let result = self.compare(date)
        return result == .OrderedSame || result == .OrderedAscending
    }
    
    public func isAfter(date: NSDate) -> Bool {
    
        return self.compare(date) == .OrderedDescending
    }
    
    public func isOnOrAfter(date: NSDate) -> Bool {
        
        let result = self.compare(date)
        return result == .OrderedSame || result == .OrderedDescending
    }
    
}
