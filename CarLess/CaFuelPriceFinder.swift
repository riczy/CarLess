import Foundation


/**

The fuel prices are obtained from US EIS open data sets initiative. 
The data obtained in this class are weekly retail fuel prices for the entire U.S., all grades and all formulations. Pricing units are expressed in dollars per gallon.

*/
class CaFuelPriceFinder: NSObject {
    
    func fuelPrice(forDate date: NSDate, onSuccess success: ((fuelPrice: EiaWeeklyFuelPrice) -> Void)?) {
        
        let url = NSURL(string: "http://api.eia.gov/series/?api_key=9F0C0802DE3E806D5F94A83679D6A002&series_id=PET.EMM_EPM0_PTE_NUS_DPG.W")
        let urlRequest = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            
            if error == nil && data != nil {
                
                do {
                    let parser = EiaWeeklyFuelPriceParser(data: data!)
                    let price = try parser.parsePriceForDate(date)
                    if price != nil {
                        success?(fuelPrice: price!)
                    }
                } catch {
                    NSLog("The EIA weekly fuel price data could not be parsed. Response url = \(response?.URL), Error = \(error), Data = \(data)")
                }
            } else {
                NSLog("An error occurred when fetching the EIA weekly fuel prices. Response url = \(response?.URL). Error = \(error). Data = \(data)")
            }
        }
    }
}