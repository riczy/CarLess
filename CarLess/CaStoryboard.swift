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
    static let SaveDisplayAlpha: CGFloat = 0.3
}

struct CaColor {

    // Hex 3B3833
    static let FadedSlateGray = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 49.0/255.0, alpha: 1.0) // 3B3B31

    // Lime
    static let Lime200 = UIColor(red: 240.0/255.0, green: 244.0/255.0, blue: 195.0/255.0, alpha: 1.0) // D4E157
    static let Lime400 = UIColor(red: 212.0/255.0, green: 225.0/255.0, blue: 87.0/255.0, alpha: 1.0) // D4E157
    static let Lime500 = UIColor(red: 205.0/255.0, green: 220.0/255.0, blue: 57.0/255.0, alpha: 1.0) // CDDC39
    static let Lime700 = UIColor(red: 175.0/255.0, green: 180.0/255.0, blue: 43.0/255.0, alpha: 1.0) // AFB42B
    static let Lime900 = UIColor(red: 130.0/255.0, green: 119.0/255.0, blue: 23.0/255.0, alpha: 1.0) // 827717
    
    // Blue
    static let Blue500 = UIColor(red: 33.0/255.0, green: 150.0/255.0, blue: 243.0/255.0, alpha: 1.0) // 2196F3
    static let Blue700 = UIColor(red: 25.0/255.0, green: 118.0/255.0, blue: 210.0/255.0, alpha: 1.0) // 1976D2
    
    // Light Blue
    static let LightBlue900 = UIColor(red: 1.0/255.0, green: 87.0/255.0, blue: 155.0/255.0, alpha: 1.0) // 01579B
    
    // Light Green
    static let LightGreen900 = UIColor(red: 51.0/255.0, green: 105.0/255.0, blue: 30.0/255.0, alpha: 1.0) // 33691E
    
    // Red
    static let Red400 = UIColor(red: 239.0/255.0, green: 83.0/255.0, blue: 80.0/255.0, alpha: 1.0) // EF5350
    static let Red600 = UIColor(red: 229.0/255.0, green: 57.0/255.0, blue: 53.0/255.0, alpha: 1.0) // E53935
    static let Red700 = UIColor(red: 211.0/255.0, green: 47.0/255.0, blue: 47.0/255.0, alpha: 1.0) // D32F2F
    static let Red900 = UIColor(red: 183.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0) // B71C1C
    
    // Grey
    static let Grey900 = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1.0) // 212121
}

struct CaStyle {
    
    static let LeftViewPadding: CGFloat = 15.0
    static let RightViewPadding: CGFloat = 15.0
    
    static let ButtonWidth: CGFloat = 132.0
    static let ButtonHeight: CGFloat = 42.0
    static let ButtonBorderWidth: CGFloat = 0.0
    
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
    static let InputFieldHrThickness: CGFloat = 1.0
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
            let fontDescriptor = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
            return UIFont(descriptor: fontDescriptor, size: 0)
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
    static let MpgValueColor = CaColor.Red400
 
    // MARK: - Log Specific
    static var LogDistanceDisplayFont: UIFont {
        get {
            let font = UIFont.preferredFontForTextStyle(UIFontTextStyleTitle1)
            let fontDescriptor = font.fontDescriptor()
            var fontAttributes = [String : AnyObject]()
            fontAttributes[UIFontDescriptorFeatureSettingsAttribute] = [
                [
                    UIFontFeatureTypeIdentifierKey : kNumberSpacingType,
                    UIFontFeatureSelectorIdentifierKey : kMonospacedNumbersSelector
                ]
            ]
            let propDescriptor = fontDescriptor.fontDescriptorByAddingAttributes(fontAttributes)
            return UIFont(descriptor: propDescriptor, size: 0)
        }
    }
    static let LogSegmentControlColor = UIColor.blackColor()
    static let LogSaveButtonColor = UIColor.whiteColor()
    static let LogSaveButtonBgColor = CaColor.LightBlue900
    static let LogSaveButtonBorderColor = CaColor.LightBlue900
    static let LogStartButtonColor = UIColor.whiteColor()
    static let LogStartButtonBgColor = CaColor.LightGreen900
    static let LogStartButtonBorderColor = CaColor.LightGreen900
    static let LogDistanceLabelColor = UIColor.whiteColor()
    static let LogDistanceDisplayColor = UIColor.whiteColor()
    static let LogProgressViewBgColor = CaColor.Red700
    static let LogProgressViewHrColor = CaColor.Red900
    static let LogStopButtonColor = UIColor.whiteColor()
    static let LogStopButtonBgColor = CaColor.Red700
    static let LogStopButtonBorderColor = CaColor.Red700
    
    
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