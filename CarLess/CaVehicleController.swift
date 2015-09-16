import UIKit

class CaVehicleController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getVehicleYears()
        getVehicleMakes(forYear: "2012")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func getVehicleYears() {
        
        let baseUrl = NSURL(string: "http://www.fueleconomy.gov")
        let url = NSURL(string: "ws/rest/vehicle/menu/year", relativeToURL: baseUrl)
        
        let urlRequest = NSURLRequest(URL: url!)
        let queue = NSOperationQueue.currentQueue() // ??????
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, error) -> Void in
            
            var parserDelegate = EpaVehicleMenuParser()
            var parser = NSXMLParser(data: data)
            parser.delegate = parserDelegate
            parser.parse()
            println("parsed array = \(parserDelegate.values)")
        }
    }
    
    private func getVehicleMakes(forYear year: String) {
        
        let baseUrl = NSURL(string: "http://www.fueleconomy.gov")
        let url = NSURL(string: "ws/rest/vehicle/menu/make?year=\(year)", relativeToURL: baseUrl)
        
        let urlRequest = NSURLRequest(URL: url!)
        let queue = NSOperationQueue.currentQueue() // ??????
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, error) -> Void in
            
            var parserDelegate = EpaVehicleMenuParser()
            var parser = NSXMLParser(data: data)
            parser.delegate = parserDelegate
            parser.parse()
            println("parsed array = \(parserDelegate.values)")
        }
   }
    

}
