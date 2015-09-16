import Foundation

class EpaParser : NSObject, NSXMLParserDelegate {
    
    enum Status {
        
        case NotStarted
        case InProgress
        case Failed
        case Completed
    }
    
    var status = Status.NotStarted

    func parserDidStartDocument(parser: NSXMLParser) {
        
        status = Status.InProgress
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        
        status = Status.Completed
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        
        status = Status.Failed
    }

}
