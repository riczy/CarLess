import Foundation

class MilestoneCalculator {
    
    static let milestones = [
            Milestone(milestone: .AroundTheWorld, level: .Platinum, onetimeAward: false, description: "Distance travelled equals a trip around the world"),
            Milestone(milestone: .CarTank, level: .Bronze, onetimeAward: false, description: "Saved as much fuel as the average car"),
            Milestone(milestone: .Enthusiast, level: .Silver, onetimeAward: true, description: "Made at least one car free trip each day for 30 consecutive days"),
            Milestone(milestone: .Fanatic, level: .Gold, onetimeAward: false, description: "Made at least one car free trip each day for 100 consecutive days"),
            Milestone(milestone: .GoGetter, level: .Bronze, onetimeAward: true, description: "Made at least one car free trip each day for 7 consecutive days"),
            Milestone(milestone: .JetSmasher, level: .Gold, onetimeAward: false, description: "CO2 saved equals a flight from NY to London"),
            Milestone(milestone: .Legendary, level: .Platinum, onetimeAward: false, description: "Made a least one car free trip each day for one year"),
            Milestone(milestone: .TankerTruck, level: .Platinum, onetimeAward: false, description: "Saved as much fuel carried by the average tanker truck")
    ]
    
}

enum MilestoneType: String {
    
    case GoGetter = "GoGetter"
    case Enthusiast = "Enthusiast"
    case Fanatic = "Fanatic"
    case Legendary = "Legendary"
    case CarTank = "CarTank"
    case TankerTruck = "TankerTruck"
    case JetSmasher = "JetSmasher"
    case AroundTheWorld = "AroundTheWorld"
    
    var description: String {
        
        get {
            return self.rawValue
        }
    }
    
    var title: String {
        
        get {
            switch self {
            case .GoGetter:
                return "Go Getter"
            case .Enthusiast:
                return "Enthusiast"
            case .Fanatic:
                return "Fanatic"
            case .Legendary:
                return "Legendary"
            case .CarTank:
                return "Car Tank"
            case .TankerTruck:
                return "Tanker"
            case .JetSmasher:
                return "Jet Smasher"
            case .AroundTheWorld:
                return "Around the World"
            }
        }
    }
    
}

enum MilestoneLevel: String {
    
    case Bronze = "Bronze"
    case Silver = "Silver"
    case Gold = "Gold"
    case Platinum = "Platinum"
}

struct Milestone {
    
    var milestone: MilestoneType
    var level: MilestoneLevel
    var onetimeAward: Bool
    var description: String
}