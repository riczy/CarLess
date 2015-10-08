import Foundation

class CaTripsSummary: NSObject {
    
    var startDate: NSDate
    var endDate: NSDate
    var tripsCount: Int = 0
    var moneySavedTotal: Double = 0.0
    var fuelSavedTotal: Double = 0.0
    
    override var description: String {
        get {
            return "\(startDate) - \(endDate) | tripsCount = \(tripsCount), moneySavedTotal = \(moneySavedTotal), fuelSavedTotal = \(fuelSavedTotal)"
        }
    }
    
    convenience init(startDate: NSDate, endDate: NSDate) {
        
        self.init(startDate: startDate, endDate: endDate, tripsCount: 0, moneySavedTotal: 0.0, fuelSavedTotal: 0.0)
    }
    
    init(startDate: NSDate, endDate: NSDate, tripsCount: Int, moneySavedTotal: Double, fuelSavedTotal: Double) {
        
        self.startDate = startDate
        self.endDate = endDate
        self.tripsCount = tripsCount
        self.moneySavedTotal = moneySavedTotal
        self.fuelSavedTotal = fuelSavedTotal
    }
    
    func isWithinRange(trip: Trip) -> Bool {
    
        return trip.startTimestamp.isOnOrAfter(startDate) && trip.startTimestamp.isOnOrBefore(endDate)
    }
    
    func add(trip: Trip) -> Bool {
        
        if isWithinRange(trip) {
            
            ++tripsCount
            if let money = trip.moneySaved() {
                moneySavedTotal += money
            }
            if let fuel = trip.fuelSaved() {
                fuelSavedTotal += fuel
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
    
    init(data: [Trip], period: SummaryPeriod) {
        
        self.data = data
        self.period = period
    }
    
    mutating func collate() -> [CaTripsSummary] {
        
        for trip in data {
            let dateRange: (startDate: NSDate, endDate: NSDate) = period == SummaryPeriod.Weekly ? trip.startTimestamp.weekRange() : trip.startTimestamp.monthRange()
            if let value = summaryDataMap[dateRange.startDate] {
                value.add(trip)
            } else {
                let summary = CaTripsSummary(startDate: dateRange.startDate, endDate: dateRange.endDate)
                summary.add(trip)
                summaryDataMap[dateRange.startDate] = summary
            }
        }
        var results = [CaTripsSummary]()
        let sortedMap = summaryDataMap.sort { $0.0.isAfter($1.0) }
        for (_, value) in sortedMap {
            results.append(value)
        }
        return results
    }
    
}
