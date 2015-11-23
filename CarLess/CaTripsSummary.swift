import Foundation

class CaTripsSummary: NSObject {
    
    private let currencyBehavior = NSDecimalNumberHandler.defaultCurrencyNumberHandler()
    var startDate: NSDate
    var endDate: NSDate
    var tripsCount: Int = 0
    var moneySavedTotal: NSDecimalNumber = 0
    var fuelSavedTotal: Double = 0
    var co2SavedTotal: Double = 0
    var distanceTotal: Double = 0
    
    override var description: String {
        get {
            return "\(startDate) - \(endDate) | tripsCount = \(tripsCount), distanceTotal = \(distanceTotal), moneySavedTotal = \(moneySavedTotal), fuelSavedTotal = \(fuelSavedTotal), co2SavedTotal = \(co2SavedTotal)"
        }
    }

    init(startDate: NSDate, endDate: NSDate) {
    
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func distanceInUnit(unit: LengthUnit) -> Double {
        
        return distanceTotal * unit.conversionFactor
    }
    
    func isWithinRange(trip: Trip) -> Bool {
    
        return trip.startTimestamp.isOnOrAfter(startDate) && trip.startTimestamp.isOnOrBefore(endDate)
    }
    
    func add(trip: Trip) -> Bool {
        
        if isWithinRange(trip) {
            
            ++tripsCount
            distanceTotal += trip.distance.doubleValue
            if let money = trip.moneySaved() {
                moneySavedTotal = moneySavedTotal.decimalNumberByAdding(money, withBehavior: currencyBehavior)
            }
            if let fuel = trip.fuelSaved() {
                fuelSavedTotal += fuel
            }
            if let co2 = trip.co2Saved() {
                co2SavedTotal += co2
            }
            return true
        }
        return false
    }
    
}

enum SummaryPeriod {
    
    case Weekly
    case Monthly
}

struct CaTripsSummaryCollator {

    var data: [Trip]!
    var period: SummaryPeriod!
    private var summaryDataMap = [NSDate : CaTripsSummary]()
    private var grandTotalSummary = CaTripsSummary(startDate: NSDate(), endDate: NSDate())
    
    init(data: [Trip], period: SummaryPeriod) {
        
        self.data = data
        self.period = period
    }
    
    mutating func collate() -> ([CaTripsSummary], CaTripsSummary) {
        
        for trip in data {
            let dateRange: (startDate: NSDate, endDate: NSDate) = period == SummaryPeriod.Weekly ? trip.startTimestamp.weekRange() : trip.startTimestamp.monthRange()
            if let value = summaryDataMap[dateRange.startDate] {
                value.add(trip)
            } else {
                let summary = CaTripsSummary(startDate: dateRange.startDate, endDate: dateRange.endDate)
                summary.add(trip)
                summaryDataMap[dateRange.startDate] = summary
            }
            addTripToGrandTotal(trip, withRange: dateRange)
        }
        var results = [CaTripsSummary]()
        let sortedMap = summaryDataMap.sort { $0.0.isAfter($1.0) }
        for (_, value) in sortedMap {
            results.append(value)
        }
        return (results, grandTotalSummary)
    }
    
    private func addTripToGrandTotal(trip: Trip, withRange range: (startDate: NSDate, endDate: NSDate)) {
        
        if range.startDate.isBefore(grandTotalSummary.startDate) {
            grandTotalSummary.startDate = range.startDate
        }
        
        if range.endDate.isAfter(grandTotalSummary.endDate) {
            grandTotalSummary.endDate = range.endDate
        }
        
        grandTotalSummary.add(trip)
    }
    
}
