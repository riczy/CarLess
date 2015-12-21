import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var context: NSManagedObjectContext!
    var window: UIWindow?
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        initializePersistentStore()
        CaDataManager.instance.context = context
        CaDataManager.instance.defaultDistanceUnit
        MigrationManager().run()
        return true
    }
    
    private func initializePersistentStore() {
        
        guard let modelURL = NSBundle.mainBundle().URLForResource("CarLess", withExtension: "momd") else {
            fatalError("Error loading model from bundle.")
        }
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing managed object model from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc

        // Not running the following statements in dispatch_async to avoid running
        // in the background. Some setup may need to occur and we need to guarantee
        // that the persistent store is available before the setup is executed.
        //
        let options = [ NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true ]
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let docURL = urls[urls.endIndex - 1]
        let storeURL = docURL.URLByAppendingPathComponent("DataModel.sqlite")
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        } catch {
            fatalError("Error opening persistent data store: \(error)")
        }
    }
}

