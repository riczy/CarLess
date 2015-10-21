import Foundation

extension NSDecimalNumberHandler {

    /// Returns a decimal number handler that provides a default rounding and scaling
    /// behavior for currency. Specifically, the rounding mode is NSRoundingMode.RoundPlain
    /// and the scale is 2.
    ///
    class func defaultCurrencyNumberHandler() -> NSDecimalNumberHandler {
        return NSDecimalNumberHandler(roundingMode: NSRoundingMode.RoundPlain, scale: 2, raiseOnExactness: true, raiseOnOverflow: true, raiseOnUnderflow: true, raiseOnDivideByZero: true)
    }
}
