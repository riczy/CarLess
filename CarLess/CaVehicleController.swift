import UIKit

class CaVehicleController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getYears()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func getYears() {
        
        let baseUrl = NSURL(string: "http://www.fueleconomy.gov")
        let url = NSURL(string: "ws/rest/vehicle/menu/year", relativeToURL: baseUrl)
        
        let urlRequest = NSURLRequest(URL: url!)
        let queue = NSOperationQueue.currentQueue() // ??????
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, error) -> Void in
            println("data = \(data)")
            println("error = \(error)")
            println("response = \(response)")
            
            var parserDelegate = EpaVehicleYearParser()
            var parser = NSXMLParser(data: data)
            parser.delegate = parserDelegate
            parser.parse()
        }
    }
    

}
