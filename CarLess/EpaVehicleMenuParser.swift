import Foundation

///
/// The parser delegate for the EPA's Fuel Economy web service's vehicle menu
/// selectors.
/// The parser supports the vehicle year, vehicle make, vehicle model, and
/// vehicle options menus. Each of those are composed of a text and a value
/// element inside of a menuItem elemnt.
///
/// See http://www.fueleconomy.gov/feg/ws/index.shtml
///
class EpaVehicleMenuParser : NSObject, NSXMLParserDelegate {
    
    enum Status {
        
        case NotStarted
        case InProgress
        case Failed
        case Completed
    }
    
    enum Element: String {
        
        case Text = "text"
        case Value = "value"
        case MenuItem = "menuItem"
    }
    
    
    var status = Status.NotStarted
    var values: [String : String] = [:]
    
    private var text: NSMutableString = ""
    private var value: NSMutableString = ""
    private var currentElement: Element?

    func parserDidStartDocument(parser: NSXMLParser) {
        
        status = Status.InProgress
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        status = Status.Completed
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
        status = Status.Failed
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        if elementName == Element.Text.rawValue {
            currentElement = Element.Text
        } else if elementName == Element.Value.rawValue {
            currentElement = Element.Value
        } else {
            currentElement = nil
            if elementName == Element.MenuItem.rawValue {
                text = ""
                value = ""
            }
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == Element.MenuItem.rawValue {
            values.updateValue(value as String, forKey: text as String)
        }
        self.currentElement = nil
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        
        if string != nil {
            if currentElement == Element.Text {
                text.appendString(string!)
            } else if currentElement == Element.Value {
                value.appendString(string!)
            }
        }
    }
}