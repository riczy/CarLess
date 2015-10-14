import Foundation
import CoreGraphics
import UIKit

struct CaSegue {
    
    static let LogTrackedTripHomeToProgress = "LogTrackedTripHomeToProgressSegue"
    static let LogTrackedTripProgressToSummary = "LogTrackedTripProgressToSummarySegue"
    static let LogTrackedTripSummaryToHome = "LogTrackedTripSummaryToHomeSegue"
    static let LogManualTripHomeToSummary = "LogManualTripHomeToSummarySegue"
    static let LogManualTripSummaryToHome = "LogManualTripSummaryToHomeSegue"
    
    static let SettingsToVehicle = "SettingsToVehicleSegue"
    static let VehicleToSettings = "VehicleToSettingsSegue"
    static let SettingsToDistanceUnit = "SettingsToDistanceUnitSegue"
    static let DistanceUnitToSettings = "DistanceUnitToSettingsSegue"
    
    static let TripsHomeToTripPeriodicSummary = "TripsHomeToTripPeriodicSummarySegue"
    static let TripPeriodicSummaryToTripsHome = "TripPeriodicSummaryToTripsHomeSegue"
}

struct CaConstants {
    
    static let SaveActivityDelay = 2.0 * Double(NSEC_PER_SEC)
    static let SaveDisplayAlpha: CGFloat = 0.5
}

struct CaColor {

    // Hex 3B3833
    static let FadedSlateGray = UIColor(red: 59.0/255.0, green: 56.0/255.0, blue: 51.0/255.0, alpha: 1.0)

    // Hex E9BC1B
    static let Mustard = UIColor(red: 233.0/255.0, green: 188.0/255.0, blue: 27.0/255.0, alpha: 1.0)

    // Hex F5EACD
    static let Ivory = UIColor(red: 245.0/255.0, green: 234.0/255.0, blue: 205.0/255.0, alpha: 1.0)
    
    // Hex FBF6EA
    static let PaleIvory = UIColor(red: 251.0/255.0, green: 246.0/255.0, blue: 234.0/255.0, alpha: 1.0)
   
    // Hex EE4B3E
    static let RedOrange = UIColor(red: 238.0/255.0, green: 75.0/255.0, blue: 62.0/255.0, alpha: 1.0)
    
    // Hex 096EA0
    static let LightBlue = UIColor(red: 9.0/255.0, green: 110.0/255.0, blue: 160.0/255.0, alpha: 1.0)

    // Hex 1F784F
    static let HunterGreen = UIColor(red: 31.0/255.0, green: 120.0/255.0, blue: 79.0/255.0, alpha: 1.0)

    
    // Hex BFE0E8
    static let PalePowderBlue = UIColor(red: 191.0/255.0, green: 224.0/255.0, blue: 232.0/255.0, alpha: 1.0)
    
    // Hex 29D3FF
    static let PowderBlue = UIColor(red: 41.0/255.0, green: 211.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    // Hex BFE8C0
    static let PaleSeaGreen = UIColor(red: 191.0/255.0, green: 232.0/255.0, blue: 192.0/255.0, alpha: 1.0)
    
    // Hex 387863
    static let SeaGreen = UIColor(red: 56.0/255.0, green: 120.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    
    // Google Design Spec Lime
    static let Lime200 = UIColor(red: 240.0/255.0, green: 244.0/255.0, blue: 195.0/255.0, alpha: 1.0) // D4E157
    static let Lime400 = UIColor(red: 212.0/255.0, green: 225.0/255.0, blue: 87.0/255.0, alpha: 1.0) // D4E157
    static let Lime500 = UIColor(red: 205.0/255.0, green: 220.0/255.0, blue: 57.0/255.0, alpha: 1.0) // CDDC39
    static let Lime700 = UIColor(red: 175.0/255.0, green: 180.0/255.0, blue: 43.0/255.0, alpha: 1.0) // AFB42B
    static let Lime900 = UIColor(red: 130.0/255.0, green: 119.0/255.0, blue: 23.0/255.0, alpha: 1.0) // 827717
    
}

struct CaStyle {
    
    static let ButtonWidth: CGFloat = 110.0
    static let ButtonHeight: CGFloat = 36.0
    static let ButtonBorderWidth: CGFloat = 0.0
    static let FontDefault = UIFont(name: "Arial Rounded MT Bold", size: 16)
    static let DefaultFontName = "Arial Rounded MT Bold"
    
    static let ViewBgColor = UIColor.whiteColor()
    static let TabBarBgTintColor = UIColor.blackColor()
    static let TabBarTintColor = CaColor.Lime400
    static let NavBarBgTintColor = CaColor.Lime700
    static let NavBarTintColor = UIColor.blackColor()

    static var InstructionHeadlineFont: UIFont {
        get {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        }
    }
    static let InstructionHeadlineColor = CaColor.FadedSlateGray
    
    // MARK: - Default Form Style Settings
    
    static var InputLabelFont: UIFont {
        get {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        }
    }
    static var InputFieldFont: UIFont {
        get {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }
    }
    static let InputLabelColor = CaColor.Lime900
    static let InputFieldColor = CaColor.FadedSlateGray
    static let InputFieldHrColor = UIColor(red: 59.0/255.0, green: 56.0/255.0, blue: 51.0/255.0, alpha: 0.3) //CaColor.Lime200
    static let InputFieldHrFocusColor = CaColor.Lime200
    static let InputFieldFontMinimumScaleFactor: CGFloat = 0.6
    
    // MARK: - Default Table Fonts
    
    static var CellLabelFont: UIFont {
        get {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        }
    }
    static var CellValueFont: UIFont {
        get {
            let fontDescriptor = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
            return UIFont(descriptor: fontDescriptor, size: 0)
        }
    }
    static var CellHeaderFont: UIFont {
        get {
            let fontDescriptor = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
            return UIFont(descriptor: fontDescriptor, size: 0)
        }
    }
    static var CellRowFont: UIFont {
        get {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }
    }
    
    // MARK: - Default Table Colors
    
    static let CellBgColor = UIColor.whiteColor()
    static let CellLabelColor = CaColor.Lime900
    static let CellValueColor = CaColor.FadedSlateGray
    
    static let CellHeaderColor = UIColor.whiteColor()
    static let CellHeaderBgColor = CaColor.FadedSlateGray
    static let CellRowColor = CaColor.FadedSlateGray
    static let CellRowBgColor = UIColor.whiteColor()
    
    static let CellValueFontMinimumScaleFactor: CGFloat = 0.6
    
    // MARK: - Vehicle Specific
    static var MpgLabelFont: UIFont {
        get {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        }
    }
    static var MpgValueFont: UIFont {
        get {
            let fontDescriptor = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
            return UIFont(descriptor: fontDescriptor, size: 0)
        }
    }
    static let MpgLabelColor = CaColor.FadedSlateGray
    static let MpgValueColor = CaColor.RedOrange
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
    static let StopButtonColor = UIColor.whiteColor()
    static let StopButtonBgColor = CaColor.RedOrange
    static let StopButtonBorderColor = CaColor.FadedSlateGray
    static let SaveButtonColor = UIColor.whiteColor()
    static let SaveButtonBgColor = CaColor.LightBlue
    static let SaveButtonBorderColor = CaColor.LightBlue
    static let DiscardButtonColor = UIColor.whiteColor()
    static let DiscardButtonBgColor = CaColor.FadedSlateGray
    static let DiscardButtonBorderColor = CaColor.FadedSlateGray
    static let MapRouteLineColor =  CaColor.LightBlue
    static let MapRouteLineWidth: CGFloat = 4
   
}

struct CaTripStyle {

    static let ViewBgColor = CaColor.Ivory
    static let CellBgColor = CaColor.PaleIvory
    static let CellTitleColor = CaColor.FadedSlateGray
    static let CellTitleFont = CaStyle.FontDefault
    static let SummaryCellBgColor = CaColor.LightBlue
    static let SummaryCellColor = UIColor.whiteColor()
    static let SummaryCellFont = CaStyle.FontDefault
    
}

struct CaTripSummaryStyle {
    
    static let ViewBgColor = CaColor.Ivory
    static let HeaderCellFont = CaStyle.FontDefault
    static let HeaderCellBgColor = CaColor.LightBlue
    static let HeaderCellColor = UIColor.whiteColor()
    static let CellFont = CaStyle.FontDefault
    static let CellBgColor = CaColor.PaleIvory
    static let CellColor = CaColor.FadedSlateGray
    
}

struct CaTripListStyle {
    
    static let ViewBgColor = CaColor.Ivory
    static let CellFont = CaStyle.FontDefault
    static let CellBgColor = CaColor.PaleIvory
    static let CellTimeColor = CaColor.FadedSlateGray
    static let CellDistanceColor = CaColor.FadedSlateGray
}

struct CaVehicleStyle {
    
    static let ViewBgColor = CaColor.Ivory
    static let ViewTitleColor = CaColor.FadedSlateGray
    static let ViewFieldColor = CaColor.FadedSlateGray
    static let ViewFieldBgColor = CaColor.PaleIvory
    static let MpgValueColor = CaColor.RedOrange
    static let MpgTitleColor = CaColor.RedOrange
}

class CaComponent {
    
    static func createButton(title title: String, color: UIColor, bgColor: UIColor, borderColor: UIColor) -> UIButton {
    
        let button = UIButton(type: UIButtonType.System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, forState: UIControlState.Normal)
        button.setTitleColor(color, forState: UIControlState.Normal)
        button.layer.backgroundColor = bgColor.CGColor
        button.layer.borderColor = borderColor.CGColor
        button.layer.cornerRadius = CaStyle.ButtonHeight/2.0
        button.layer.borderWidth = CaStyle.ButtonBorderWidth
        return button
    }
}