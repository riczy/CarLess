import Foundation


/**

The fuel prices are obtained from US EIS open data sets initiative. 
The data obtained in this class are weekly retail fuel prices for the entire U.S., all grades and all formulations. Pricing units are expressed in dollars per gallon.

*/
class CaFuelPriceFinder: NSObject {
    
    static let instance = CaFuelPriceFinder()
    private var cache = CaFuelPriceCache()
    
    private override init() {
    }
    
    func fuelPrice(forDate date: NSDate, onSuccess: ((fuelPrice: EiaWeeklyFuelPrice) -> Void)?, onError: (() -> Void)?) {
        
        if let cachedPrice = cache.find(date) {
            onSuccess?(fuelPrice: cachedPrice)
            return
        }
        
        let url = NSURL(string: "http://api.eia.gov/series/?api_key=9F0C0802DE3E806D5F94A83679D6A002&series_id=PET.EMM_EPM0_PTE_NUS_DPG.W")
        let sessionTask = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
            
                if error == nil && data != nil {
                    
                    do {
                        let parser = EiaWeeklyFuelPriceParser(data: data!)
                        let price = try parser.parsePriceForDate(date)
                        if price != nil {
                            self.cache.add(price!)
                            onSuccess?(fuelPrice: price!)
                            return
                        }
                    } catch {
                        NSLog("The EIA weekly fuel price data could not be parsed. Response url = \(response?.URL), Error = \(error), Data = \(data)")
                    }
                } else {
                    NSLog("An error occurred when fetching the EIA weekly fuel prices. Response url = \(response?.URL). Error = \(error). Data = \(data)")
                }
                onError?()
            }
        }
        sessionTask.resume()
    }
}

struct CaFuelPriceCache {
    
    private let maxCacheSize = 5
    private var cache = [EiaWeeklyFuelPrice]()
    
    private mutating func find(date: NSDate) -> EiaWeeklyFuelPrice? {
        
        let index = cacheIndex(forDate: date)
        
        if index != nil  {
            let fuelPriceObject = cache[index!]
            if index > 0 {
                cache.removeAtIndex(index!)
                cache.insert(fuelPriceObject, atIndex: 0)
            }
            return fuelPriceObject
        }
        
        return nil
    }
    
    mutating func add(fuelPrice: EiaWeeklyFuelPrice) {
        
        let index = cacheIndex(forFuelPriceObject: fuelPrice)
        // If exists already then do nothing.
        // It doesn't exist in cache, therefore add it. But, make sure to stay
        // under cache maximum.
        if index == nil {
            if cache.count >= maxCacheSize {
                cache.removeLast()
            }
            cache.insert(fuelPrice, atIndex: 0)
        }
    }
    
    private func cacheIndex(forDate date: NSDate) -> Int? {
        
        if !cache.isEmpty {
            for index in 0...cache.count - 1 {
                let cacheObj = cache[index]
                if cacheObj.isDateWithinRange(date) {
                    return index
                }
            }
        }
        return nil
    }
    
    private func cacheIndex(forFuelPriceObject fuelPrice: EiaWeeklyFuelPrice) -> Int? {
        
        if !cache.isEmpty {
            for index in 0...cache.count - 1 {
                let cacheObj = cache[index]
                if cacheObj.startDate == fuelPrice.startDate {
                    return index
                }
            }
        }
        return nil
    }
}