import Foundation

struct EpaVehicle : Printable {
    
    var id: String
    var year: String
    var make: String
    var model: String

    var comb08: Int?
    var comb08U: Double?
    var combA08: Int?
    var combA08U: Double?
    
    var description: String {
        
        return "\(id), \(year), \(make), \(model)"
    }
    
    init(id: String, year: String, make: String, model: String) {
        
        self.id = id
        self.year = year
        self.make = make
        self.model = model
    }
}

///
/// The parser delegate for a specific vehicle record  in EPA's Fuel Economy web
/// service.
///
/// See http://www.fueleconomy.gov/feg/ws/index.shtml#vehicle for the data
/// description.
///
/// Use /ws/rest/vehicle/{id} for the data service.
///
class EpaVehicleParser : NSObject, NSXMLParserDelegate {
    
    enum Element: String {
        
        case Id = "id"
        case Year = "year"
        case Make = "make"
        case Model = "model"
        case CombinedMpgFuelType1 = "comb08"
        case CombinedMpgFuelType1Unrounded = "comb08U"
        case CombinedMpgFuelType2 = "combA08"
        case CombinedMpgFueltype2Unrounded = "combA08U"
    }
    
    var value: EpaVehicle?
    
    // Using a working value because we won't know the id, year, make and
    // model until all the parsing is completed. However, those values are
    // required. Will set the workingValue to the value upon completion of
    // parsing.
    private var workingValue = EpaVehicle(id: "", year: "", make: "", model: "")
    private var currentElement: Element?
    private var currentElementValue: NSMutableString = ""
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        switch elementName {
        case Element.Id.rawValue:
            currentElement = Element.Id
        case Element.Year.rawValue:
            currentElement = Element.Year
        case Element.Make.rawValue:
            currentElement = Element.Make
        case Element.Model.rawValue:
            currentElement = Element.Model
        case Element.CombinedMpgFuelType1.rawValue:
            currentElement = Element.CombinedMpgFuelType1
        case Element.CombinedMpgFuelType1Unrounded.rawValue:
            currentElement = Element.CombinedMpgFuelType1Unrounded
        case Element.CombinedMpgFuelType2.rawValue:
            currentElement = Element.CombinedMpgFuelType2
        case Element.CombinedMpgFueltype2Unrounded.rawValue:
            currentElement = Element.CombinedMpgFueltype2Unrounded
        default:
            currentElement = nil
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        switch elementName {
        case Element.Id.rawValue:
            workingValue.id = currentElementValue as String
        case Element.Year.rawValue:
            workingValue.year = currentElementValue as String
        case Element.Make.rawValue:
            workingValue.make = currentElementValue as String
        case Element.Model.rawValue:
            workingValue.model = currentElementValue as String
        case Element.CombinedMpgFuelType1.rawValue:
            workingValue.comb08 = 0
        case Element.CombinedMpgFuelType1Unrounded.rawValue:
            workingValue.comb08U = 0.0
        case Element.CombinedMpgFuelType2.rawValue:
            workingValue.combA08 = 0
        case Element.CombinedMpgFueltype2Unrounded.rawValue:
            workingValue.combA08U = 0.0
        default:
            currentElementValue = ""
            currentElement = nil
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        
        if string != nil {
            currentElementValue.appendString(string!)
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        self.value = self.workingValue
    }
}