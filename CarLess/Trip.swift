import Foundation
import CoreData
import CoreLocation

@objc(Trip)
class Trip: NSManagedObject {

    @NSManaged private var categoryTypeCode: String?
    @NSManaged var distance: NSNumber
    @NSManaged var endTimestamp: NSDate?
    @NSManaged var fuelPrice: NSDecimalNumber?
    @NSManaged var fuelPriceDate: NSDate?
    @NSManaged var fuelPriceSeriesId: String?
    @NSManaged var id: String
    @NSManaged private var logTypeCode: String
    @NSManaged private var modeTypeCode: String
    @NSManaged var points: NSNumber
    @NSManaged var pending: Bool
    @NSManaged var startTimestamp: NSDate
    @NSManaged var vehicle: Vehicle?
    @NSManaged var waypoints: NSMutableSet
    
    var categoryType: Category? {
        get {
            if categoryTypeCode != nil {
                return Category(rawValue: categoryTypeCode!)
            }
            return nil
        }
        set {
            categoryTypeCode = newValue?.rawValue
        }
    }
    
    var logType: LogType {
        get {
            return LogType(rawValue: logTypeCode)!
        }
        set {
            logTypeCode = newValue.rawValue
        }
    }
    
    var modeType: Mode {
        get {
            return Mode(rawValue: modeTypeCode)!
        }
        set {
            modeTypeCode = newValue.rawValue
        }
    }
    
    var mpg: Double? {
        get {
            return vehicle?.combinedMpg
        }
    }
    
    func distanceInUnit(unit: LengthUnit) -> Double {
        
        return distance.doubleValue * unit.conversionFactor
    }
    
    func setDistance(distance: NSNumber, hasUnitType unit: LengthUnit) {
        
        // Convert distance to meters
        self.distance = distance.doubleValue / unit.conversionFactor
    }
    
    //
    // Return the money, in US dollars, saved by taking this car less trip.
    //
    // The savings cannot be calculated if the vehicle setting is not established.
    //
    func moneySaved() -> NSDecimalNumber? {
        
        let currencyBehavior = NSDecimalNumberHandler.defaultCurrencyNumberHandler()

        if fuelPrice != nil && mpg != nil {
            if !(fuelPrice!.isEqualToNumber(NSDecimalNumber.notANumber())) {
                var value = fuelPrice!.decimalNumberByMultiplyingBy(NSDecimalNumber(double: distanceInUnit(LengthUnit.Mile)), withBehavior: currencyBehavior)
                value = value.decimalNumberByDividingBy(NSDecimalNumber(double: mpg!), withBehavior: currencyBehavior)
                return value
            }
        }
        return nil
    }
    
    //
    // Return the fuel, in gallons, saved by taking this car less trip.
    //
    // The savings cannot be calculated if the vehicle setting is not established.
    //
    func fuelSaved() -> Double? {
        
        if mpg != nil {
            return distanceInUnit(LengthUnit.Mile) / mpg!
        }
        return nil
    }
    
    //
    // Returned the estimated CO2 that was saved by taking this trip.
    //
    // The CO2 cannot be calculated if the vehicle setting is not established.
    //
    func co2Saved() -> Double? {
        
        if vehicle != nil && mpg != nil {
            let atvType = vehicle!.atvType
            let distanceInMiles = distanceInUnit(LengthUnit.Mile)
            let co2Coefficient = atvType?.lowercaseString == "diesel" ? 22.4 : 19.6
            return (co2Coefficient / mpg!) * distanceInMiles
        }
        return nil
    }
}
