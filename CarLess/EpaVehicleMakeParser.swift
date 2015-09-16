import Foundation

class EpaVehicleMakeParser : EpaParser {
    
    enum Element: String {
        
        case Text = "text"
        case Value = "value"
        case MenuItem = "menuItem"
    }
    
    var makes: [EpaVehicleMake] = []
    
    private var text: NSMutableString = ""
    private var value: NSMutableString = ""
    private var currentElement: Element?
    
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
            let make = EpaVehicleMake(text: text as String, value: value as String)
            makes.append(make)
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