import CoreData
import Foundation

class MigrationManager {
    
    var migrations: Set<Int> = [ 2 ]
    
    func run() {
        
        let uncompletedMigrations = fetchUncompletedMigrations()
        for version in uncompletedMigrations {
            if version == 2 {
                let result = dataMigrationVersion2()
                if !result {
                    NSLog("The data migration for version #2 failed.")
                }
            }
        }
    }
    
    // Fetches the migrations that have not yet been completed. The list is in
    // sorted order from the lowest migration number to the highest.
    //
    private func fetchUncompletedMigrations() -> [Int] {
        
        let fetchRequest = NSFetchRequest(entityName: "Migration")
        fetchRequest.includesPendingChanges = false
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        
        var results: [Migration]?
        
        do {
            results = try CaDataManager.instance.context.executeFetchRequest(fetchRequest) as? [Migration]
        } catch let error as NSError {
            NSLog("Error when fetching Migration entities: \(error.localizedDescription)")
        }
        
        var completedMigrations = Set<Int>()
        if results != nil {
            for migration in results! {
                completedMigrations.insert(migration.version.integerValue)
            }
        }
        
        let uncompletedMigrations = migrations.subtract(completedMigrations)
        return uncompletedMigrations.sort()
    }

    // Creates a migration record for the given migration version. This indicates
    // that that migration completed successfully.
    //
    private func insertMigrationForVersion(version: Int) -> Bool {
        
        let entityDescription = NSEntityDescription.entityForName("Migration", inManagedObjectContext: CaDataManager.instance.context)
        let migration = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: CaDataManager.instance.context) as! Migration
        migration.version = version
        
        do {
            try migration.managedObjectContext!.save()
        } catch let error as NSError {
            NSLog("Error when saving migration version #\(version): \(error.localizedDescription)")
            return false
        }
        
        return true
    }
    
    private func dataMigrationVersion2() -> Bool {
        
        var trips: [Trip]!
        
        do {
            trips = try fetchAllTripsWithoutPoints()
        } catch let error as NSError {
            NSLog("Error when fetching trips with zero points: \(error.localizedDescription)")
            return false
        }
        
        for trip in trips {
            TripCreatePointsCalculator.calculatePointsForTrip(trip)
            NSLog("Trip after calc: \(trip)")
        }
        
        do {
            try CaDataManager.instance.context.save()
        } catch let error as NSError {
            NSLog("Core Data error occurred when saving context for updated trip points. \(error.localizedDescription)")
            return false
        }
        
        return insertMigrationForVersion(2)
    }
    
    private func fetchAllTripsWithoutPoints() throws -> [Trip] {
        
        let fetchRequest = NSFetchRequest(entityName: "Trip")
        
        fetchRequest.includesPendingChanges = false
        fetchRequest.predicate = NSPredicate(format: "points = %@", argumentArray: [0])
        fetchRequest.resultType = NSFetchRequestResultType.ManagedObjectResultType
        
        let results = try CaDataManager.instance.context.executeFetchRequest(fetchRequest) as? [Trip]
        
        return results == nil ? [Trip]() : results!
    }
}