import Foundation
import CoreGraphics
import UIKit

struct CaSegue {
    
    static let TrackedHomeToProgress = "TrackedHomeToProgressSegue"
    static let TrackedProgressToSummary = "TrackedProgressToSummarySegue"
    static let TrackedSummaryToHome = "TrackedSummaryToHomeSegue"
}

struct CaConstants {
    
    static let SaveActivityDelay = 3.0 * Double(NSEC_PER_SEC)
    static let SaveDisplayAlpha: CGFloat = 0.5
}

struct CaColor {

    // Hex = 00B3A9
    static let AquaTeal = UIColor(red: 0.0/255.0, green: 179.0/255.0, blue: 169.0/255.0, alpha: 1.0)

    // Hex = 004F4A
    static let DarkTeal = UIColor(red: 0.0/255.0, green: 79.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    
    // Hex = DA3A0A
    static let Orange = UIColor(red: 218.0/255.0, green: 58.0/255.0, blue: 10.0/255.0, alpha: 1.0)
    
    // Hex = BDE7BD
    static let PaleMintGreen = UIColor(red: 189.0/255.0, green: 231.0/255.0, blue: 189.0/255.0, alpha: 1.0)
    
    // Hex = 3B3833
    static let FadedSlateGray = UIColor(red: 59.0/255.0, green: 56.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    
    
    // ---
    
    // Hex = 5E9CA0
    static let MediumTeal = UIColor(red: 94.0/255.0, green: 156.0/255.0, blue: 160.0/255.0, alpha: 1.0)

    // Hex = E9BC1B
    static let Mustard = UIColor(red: 233.0/255.0, green: 188.0/255.0, blue: 27.0/255.0, alpha: 1.0)

    // Hex F5EACD
    static let Ivory = UIColor(red: 245.0/255.0, green: 234.0/255.0, blue: 205.0/255.0, alpha: 1.0)
   
    // Hex EE4B3E
    static let RedOrange = UIColor(red: 238.0/255.0, green: 75.0/255.0, blue: 62.0/255.0, alpha: 1.0)
    
    // Hex 1FDA9A
    static let MintGreen = UIColor(red: 31.0/255.0, green: 218.0/255.0, blue: 154.0/255.0, alpha: 1.0)
    
    // 1FDACE
    static let LightBlue = UIColor(red: 31.0/255.0, green: 218.0/255.0, blue: 206.0/255.0, alpha: 1.0)

    static let HunterGreen = UIColor(red: 31.0/255.0, green: 120.0/255.0, blue: 79.0/255.0, alpha: 1.0)

}

struct CaStyle {
    
    static let ButtonWidth: CGFloat = 110.0
    static let ButtonHeight: CGFloat = 36.0
    static let ButtonBorderWidth: CGFloat = 0.0
}

struct CaLogStyle {
    
    
    static let SegmentBarBgColor = CaColor.Mustard
    static let SegmentControlColor = CaColor.FadedSlateGray
    static let ViewBgColor = CaColor.Ivory
    static let ViewLabelColor = CaColor.FadedSlateGray
    static let ViewFieldColor = UIColor.blackColor()
    static let ActivitySpinnerColor = CaColor.RedOrange
    static let StartButtonColor = UIColor.whiteColor()
    static let StartButtonBgColor = CaColor.HunterGreen
    static let StartButtonBorderColor = CaColor.FadedSlateGray
    
}