enum Mode: Printable {
    
    case Walk
    case Bicycle
    case Rideshare
    case Bus
    case Train
    
    var imageFilename: String {
        get {
            switch self {
            case .Walk:
                return "trans-walk"
            case .Bicycle:
                return "trans-bike"
            case .Bus:
                return "trans-bus"
            case .Train:
                return "trans-train"
            case .Rideshare:
                return "trans-rideshare"
            }
        }
    }
    
    var description: String {
        get {
            switch self {
            case .Walk:
                return "Walk"
            case .Bicycle:
                return "Bicycle"
            case .Bus:
                return "Bus"
            case .Train:
                return "Train"
            case .Rideshare:
                return "Rideshare"
            }
            
        }
    }
    
    static let allValues = [Walk, Bicycle, Bus, Train, Rideshare]
}
