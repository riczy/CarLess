import Foundation

class EpaVehicleYearParser : NSObject, NSXMLParserDelegate {
    
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
    var years: [EpaVehicleYear] = []
    
    private var text: NSMutableString = ""
    private var value: NSMutableString = ""
    private var currentElement: Element?
    private let formatter = NSNumberFormatter()
    
    override init() {
        
        super.init()
        self.formatter.maximumFractionDigits = 0
        self.formatter.minimum = 0
        self.formatter.groupingSeparator = nil
    }
    
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
            let valueNumber = formatter.numberFromString(self.value as String)!
            let year = EpaVehicleYear(text: self.text as String, value: valueNumber)
            years.append(year)
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