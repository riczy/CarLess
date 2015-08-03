enum Mode: Printable {
    
    case Bicycle
    case Walk
    case RideShare
    case BusTrain
    
    var imageFilename: String {
        get {
            switch self {
            case .Bicycle:
                return "trans-bike"
            case .Walk:
                return "trans-walk"
            case .RideShare:
                return "trans-rideshare"
            case .BusTrain:
                return "trans-transit"
            }
        }
    }
    
    var description: String {
        get {
            switch self {
            case .Bicycle:
                return "Bicycle"
            case .Walk:
                return "Walk"
            case .RideShare:
                return "Ride Share"
            case .BusTrain:
                return "Bus/Train"
            }
            
        }
    }
    
    static let allValues = [Bicycle, Walk, RideShare, BusTrain]
}
