import Foundation

struct EpaVehicleYear : Printable {
    
    var text: String
    var value: NSNumber
    var description: String {
        get {
            return "{ text = \(text), value = \(value) }"
        }
    }
    
    init(text: String, value: NSNumber) {
        
        self.text = text
        self.value = value
    }
    
}

struct EpaVehicleMake : Printable {
    
    var text: String
    var value: String
    var description: String {
        get {
            return "{ text = \(text), value = \(value) }"
        }
    }
    
    init(text: String, value: String) {
        
        self.text = text
        self.value = value
    }
  
}