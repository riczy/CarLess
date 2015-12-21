import Foundation
import CoreData

@objc(Migration)
class Migration: NSManagedObject {
    
    @NSManaged var version: NSNumber
}
