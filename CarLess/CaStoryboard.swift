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
    static let TripsHomeToTripDetail = "TripsHomeToTripDetailSegue"
    static let TripsHomeToTripSummary = "TripsHomeToTripSummarySegue"
}

struct CaConstants {
    
    static let SaveActivityDelay = 1.0 * Double(NSEC_PER_SEC)
    static let SaveDisplayAlpha: CGFloat = 1.0
}

struct CaColor {

    // Hex 3B3833
    static let FadedSlateGray = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 49.0/255.0, alpha: 1.0) // 3B3B31
    
    // Orange
    static let Orange100 = UIColor(red: 255.0/255.0, green: 224.0/255.0, blue: 178.0/255.0, alpha: 1.0) // FFE0B2
    static let Orange800 = UIColor(red: 239.0/255.0, green: 103.0/255.0, blue: 0.0, alpha: 1.0) // EF6C00
    static let Orange900 = UIColor(red: 230.0/255.0, green: 81.0/255.0, blue: 0.0, alpha: 1.0) // E65100
    
    // Light Blue
    static let LightBlue900 = UIColor(red: 1.0/255.0, green: 87.0/255.0, blue: 155.0/255.0, alpha: 1.0) // 01579B
    
    // Blue
    static let Blue500 = UIColor(red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 1.0) // 2196F3
    
    // Teal
    static let Teal50 = UIColor(red: 224.0/255.0, green: 242.0/255.0, blue: 241.0/255.0, alpha: 1.0) // E0F2F1
    static let Teal100 = UIColor(red: 178.0/255.0, green: 223.0/255.0, blue: 219.0/255.0, alpha: 1.0) // B2DFDB
    static let Teal200 = UIColor(red: 128.0/255.0, green: 203.0/255.0, blue: 196.0/255.0, alpha: 1.0) // 80CBC4
    static let Teal300 = UIColor(red: 77.0/255.0, green: 182.0/255.0, blue: 172.0/255.0, alpha: 1.0) // 4DB6AC
    static let Teal400 = UIColor(red: 38.0/255.0, green: 166.0/255.0, blue: 154.0/255.0, alpha: 1.0) // 26A69A
    static let Teal500 = UIColor(red: 0, green: 150.0/255.0, blue: 136.0/255.0, alpha: 1.0) // 009688
    static let Teal600 = UIColor(red: 0, green: 137.0/255.0, blue: 123.0/255.0, alpha: 1.0) // 00897B
    static let Teal700 = UIColor(red: 0, green: 121.0/255.0, blue: 107.0/255.0, alpha: 1.0) // 00796B
    static let Teal800 = UIColor(red: 0, green: 105.0/255.0, blue: 92.0/255.0, alpha: 1.0) // 00695C
    static let Teal900 = UIColor(red: 0, green: 77.0/255.0, blue: 64.0/255.0, alpha: 1.0) // 004D40
    
    // Red
    static let Red400 = UIColor(red: 239.0/255.0, green: 83.0/255.0, blue: 80.0/255.0, alpha: 1.0) // EF5350
    
    // Grey
    static let Grey200 = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0) // EEEEEE
    static let Grey800 = UIColor(red: 66.0/255.0, green: 66.0/255.0, blue: 66.0/255.0, alpha: 1.0) // 424242
    static let Grey900 = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1.0) // 212121
}

struct CaStyle {
    
    static let LeftViewPadding: CGFloat = 15.0
    static let RightViewPadding: CGFloat = 15.0
    
    static let ButtonWidth: CGFloat = 132.0
    static let ButtonHeight: CGFloat = 42.0
    static let ButtonBorderWidth: CGFloat = 1.0
    
    static let ViewBgColor = UIColor.whiteColor()
    static let TabBarBgTintColor = UIColor.blackColor()
    static let TabBarTintColor = CaColor.Teal300
    static let NavBarBgTintColor = CaColor.Teal700
    static let NavBarTintColor = CaColor.Teal100
    static let NavBarTitleColor = UIColor.whiteColor()
    static let SegmentControlColor = UIColor.whiteColor()

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
    static let InputLabelColor = CaColor.Teal700
    static let InputFieldColor = CaColor.FadedSlateGray
    static let InputFieldHrColor = UIColor.whiteColor()
    static let InputFieldHrThickness: CGFloat = 0.0
    static let InputFieldFontMinimumScaleFactor: CGFloat = 0.6
    
    /* The verticle (y) spacing between an input label and its value field. */
    static let InputGroupLvVerticlePadding: CGFloat = 2.0
    /* The verticle (y) spacing between the input field and the underlying HR. */
    static let InputGroupHrVerticlePadding: CGFloat = 3.0
    /* The verticle (y) spacing between two pairs of label and value. */
    static let InputGroupVerticlePadding: CGFloat = 18.0
    
    // MARK: - Default Table Fonts
    
    static var CellLabelFont: UIFont {
        get {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        }
    }
    static var CellValueFont: UIFont {
        get {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }
    }
    static var CellHeaderFont: UIFont {
        get {
            let fontDescriptor = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1).fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
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
    static let CellLabelColor = CaColor.Teal700
    static let CellValueColor = CaColor.FadedSlateGray
    
    static let CellHeaderColor = UIColor.whiteColor()
    static let CellHeaderBgColor = CaColor.Grey800
    static let CellRowColor = CaColor.FadedSlateGray
    static let CellRowBgColor = UIColor.whiteColor()
    
    static let CellValueFontMinimumScaleFactor: CGFloat = 0.6
    
    // MARK: - Trips Specific
    static var CellTripsRowFont: UIFont {
        get {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        }
    }
    static var CellTripsTotalsRowFont: UIFont {
        get {
            let fontDescriptor = CaStyle.CellTripsRowFont.fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
            return UIFont(descriptor: fontDescriptor, size: 0)
        }
    }
    static let CellTripsTotalsRowColor = CaColor.Orange900
    static let CellTripsTotalsRowBgColor = CaColor.Grey200
    
    static var TripSummarySectionHeadingFont: UIFont {
        get {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        }
    }
    static let TripSummarySectionHeadingColor = CaColor.FadedSlateGray
    
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
    static let MpgValueColor = CaColor.Red400
 
    // MARK: - Log Specific
    static var LogDistanceDisplayFont: UIFont {
        get {
            let font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
            var fontDescriptor = font.fontDescriptor()
            var fontAttributes = [String : AnyObject]()
            fontAttributes[UIFontDescriptorFeatureSettingsAttribute] = [
                [
                    UIFontFeatureTypeIdentifierKey : kNumberSpacingType,
                    UIFontFeatureSelectorIdentifierKey : kMonospacedNumbersSelector
                ]
            ]
            fontDescriptor = fontDescriptor.fontDescriptorWithSymbolicTraits(.TraitBold)
            fontDescriptor = fontDescriptor.fontDescriptorByAddingAttributes(fontAttributes)
            return UIFont(descriptor: fontDescriptor, size: 48)
        }
    }
    static let LogSegmentControlColor = CaStyle.SegmentControlColor
    static let LogHeadlineBgColor = CaColor.Teal300
    static let LogHeadlineColor = CaStyle.InstructionHeadlineColor
    static let LogSaveButtonColor = UIColor.whiteColor()
    static let LogSaveButtonBgColor = CaColor.Orange900
    static let LogSaveButtonBorderColor =  CaColor.Orange800
    static let LogStartButtonColor = UIColor.whiteColor()
    static let LogStartButtonBgColor = CaColor.Orange900
    static let LogStartButtonBorderColor = CaColor.Orange800
    static let LogDistanceLabelColor = CaColor.Orange100
    static let LogDistanceDisplayColor = UIColor.whiteColor()
    static let LogProgressViewBgColor = CaColor.Orange900
    static let LogProgressViewHrColor = CaColor.Orange800
    static let LogStopButtonColor = CaColor.LightBlue900
    static let LogStopButtonBgColor = UIColor.whiteColor()
    static let LogStopButtonBorderColor = UIColor.whiteColor()
    
    
    static let ActivitySpinnerColor = CaColor.Red400
    static let MapRouteLineColor = CaColor.Blue500.colorWithAlphaComponent(0.5)
    static let MapRouteLineWidth: CGFloat = 4
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