import Foundation

// Calculates carless reputation points for a trip that is just created.
//
class TripCreatePointsCalculator {
    
    private var trip: Trip
    
    private init(trip: Trip) {
        self.trip = trip
    }
    
    // Calculates and adds the reputation points earned as a result of taking
    // the given trip. The points are added directly to the trip's points
    // attribute.
    //
    class func calculatePointsForTrip(trip: Trip) {
        
        let calculator = TripCreatePointsCalculator(trip: trip)
        calculator.addPoints()
    }
    
    
    // Calculates and adds the reputation points earned as a result of taking
    // the trip. The points are added directly to the trip's points attribute.
    //
    private func addPoints() {
        
        var points = trip.points.intValue
        points += addPointsForTripMode()
        points += addPointsForLongDistance()
        trip.points = NSNumber(int: points)
    }
    
    // Calculates the points for the trip based on the type of carless
    // transportation that was used. The less engine-based the transportation
    // is, the greater the points awarded.
    //
    private func addPointsForTripMode() -> Int {
    
        var points: Int = 0
        
        switch trip.modeType {
        case Mode.Bicycle, Mode.Walk:
            if trip.distance.floatValue >= 500.0 {
                points += 2
            }
        case Mode.Rideshare:
            if trip.distance.floatValue >= 1800.0 {
                points += 1
            }
        case Mode.Bus, Mode.Subway, Mode.Telecommute, Mode.Train:
            points += 1
        }
    
        return points
    }
    
    // Calculates points for trip distances that are deemed long.
    //
    private func addPointsForLongDistance() -> Int {
        
        var points = 0
        
        switch trip.modeType {
        case Mode.Bicycle:
            if trip.distance.floatValue >= 33000 {
                points += 2
            }
        case Mode.Bus, Mode.Rideshare, Mode.Train:
            if trip.distance.floatValue >= 160000 {
                points += 2
            }
        case Mode.Walk:
            if trip.distance.floatValue >= 8050 {
                points += 2
            }
        default:
            points += 0
        }
        
        return points
    }
    
}