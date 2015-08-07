enum LengthUnit : Printable {
    
    case Mile
    
    var abbreviation: String {
        get {
            switch self {
            case .Mile:
                return "mi"
            }
        }
    }
    
    var description: String {
        get {
            switch self {
            case .Mile:
                return "Miles"
            }
            
        }
    }
    
    static let allValues = [ Mile ]
}