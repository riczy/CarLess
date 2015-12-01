import MapKit
import UIKit

class CaTripSummaryView: UIView {
    
    // MARK: - UI Properties
    var startTimestampLabel = UILabel()
    var co2SavedLabel = UILabel()
    var moneySavedLabel = UILabel()
    var fuelSavedLabel = UILabel()
    var co2SavedTitleLabel = UILabel()
    var moneySavedTitleLabel = UILabel()
    var fuelSavedTitleLabel = UILabel()
    var distanceLabel = UILabel()
    var modeLabel = UILabel()
    var mapView: MKMapView?
    var noMapView: UIView?
    var showMap: Bool = true
    

    init(frame: CGRect, showMap: Bool) {
        
        super.init(frame: frame)
        self.showMap = showMap
        if showMap {
            mapView = MKMapView()
        } else {
            noMapView = UIView()
        }
    }
    
    convenience init(showMap: Bool) {
        
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), showMap: showMap)
    }
    
    convenience override init(frame: CGRect) {

        self.init(frame: frame, showMap: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        styleElements()
        loadConstraints()
    }
    
    private func styleElements() {
        
        let alignment = NSTextAlignment.Center
        let valueFont: UIFont = {
            let fontDescriptor = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontDescriptor().fontDescriptorWithSymbolicTraits(UIFontDescriptorSymbolicTraits.TraitBold)
            return UIFont(descriptor: fontDescriptor, size: 0)
        }()
        let valueTitleFont: UIFont = {
            return UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        }()
        
        backgroundColor = CaStyle.ViewBgColor
        
        startTimestampLabel.font = valueFont
        startTimestampLabel.textAlignment = NSTextAlignment.Center
        startTimestampLabel.textColor = CaStyle.TripSummaryHeadingDateColor
        startTimestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        distanceLabel.font = valueFont
        distanceLabel.textAlignment = alignment
        distanceLabel.textColor = CaStyle.TripSummaryHeadingDistanceColor
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        modeLabel.font = valueTitleFont
        modeLabel.textAlignment = alignment
        modeLabel.textColor = CaStyle.TripSummaryHeadingModeColor
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        fuelSavedLabel.font = valueFont
        fuelSavedLabel.textAlignment = alignment
        fuelSavedLabel.textColor = CaStyle.TripSummarySavingsValueColor
        fuelSavedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        moneySavedLabel.font = valueFont
        moneySavedLabel.textAlignment = alignment
        moneySavedLabel.textColor = CaStyle.TripSummarySavingsValueColor
        moneySavedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        co2SavedLabel.font = valueFont
        co2SavedLabel.textAlignment = alignment
        co2SavedLabel.textColor = CaStyle.TripSummarySavingsValueColor
        co2SavedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        fuelSavedTitleLabel.font = valueTitleFont
        fuelSavedTitleLabel.text = "Fuel"
        fuelSavedTitleLabel.textAlignment = alignment
        fuelSavedTitleLabel.textColor = CaStyle.TripSummarySavingsLabelColor
        fuelSavedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        moneySavedTitleLabel.font = valueTitleFont
        moneySavedTitleLabel.text = "Money"
        moneySavedTitleLabel.textAlignment = alignment
        moneySavedTitleLabel.textColor = CaStyle.TripSummarySavingsLabelColor
        moneySavedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        co2SavedTitleLabel.font = valueTitleFont
        co2SavedTitleLabel.text = "CO\u{2082}"
        co2SavedTitleLabel.textAlignment = alignment
        co2SavedTitleLabel.textColor = CaStyle.TripSummarySavingsLabelColor
        co2SavedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        if showMap {
            mapView!.mapType = MKMapType.Standard
            mapView!.rotateEnabled = true
            mapView!.scrollEnabled = true
            mapView!.showsCompass = true
            mapView!.translatesAutoresizingMaskIntoConstraints = false
            mapView!.zoomEnabled = true
        } else {
            noMapView!.backgroundColor = UIColor.grayColor()
            noMapView!.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func loadConstraints() {
    
        let headingViewHeight: CGFloat = 130
        let savingsViewHeight: CGFloat = 80
        let viewElementVerticleMargin: CGFloat = 3
        
        let sectionLeftPadding: CGFloat = 10
        let valueWidth: CGFloat = (frame.size.width - (sectionLeftPadding * 2)) / 3.0
        
        let headingView = UIView()
        headingView.backgroundColor = CaStyle.TripSummarySectionHeadingBgColor
        headingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headingView)
        addConstraint(NSLayoutConstraint(item: headingView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: headingView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: headingView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: headingView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: headingViewHeight))
        
        headingView.addSubview(distanceLabel)
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: headingView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: headingView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: headingView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

        headingView.addSubview(startTimestampLabel)
        addConstraint(NSLayoutConstraint(item: startTimestampLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: distanceLabel, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: (viewElementVerticleMargin * -1.0)))
        addConstraint(NSLayoutConstraint(item: startTimestampLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: headingView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: startTimestampLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: headingView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        headingView.addSubview(modeLabel)
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: distanceLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: viewElementVerticleMargin))
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        
        // Savings Section
        
        let savingsView = UIView()
        savingsView.backgroundColor = CaStyle.TripSummarySectionSavingsBgColor
        savingsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(savingsView)
        addConstraint(NSLayoutConstraint(item: savingsView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: headingView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: savingsView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: savingsView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: savingsView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: savingsViewHeight))
        
        
        savingsView.addSubview(moneySavedLabel)
        addConstraint(NSLayoutConstraint(item: moneySavedLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: savingsView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: moneySavedLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: moneySavedLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: sectionLeftPadding))
        
        savingsView.addSubview(fuelSavedLabel)
        addConstraint(NSLayoutConstraint(item: fuelSavedLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: savingsView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: fuelSavedLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: fuelSavedLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: moneySavedLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        savingsView.addSubview(co2SavedLabel)
        addConstraint(NSLayoutConstraint(item: co2SavedLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: savingsView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: co2SavedLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: co2SavedLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

        
        savingsView.addSubview(moneySavedTitleLabel)
        addConstraint(NSLayoutConstraint(item: moneySavedTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: moneySavedLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: viewElementVerticleMargin))
        addConstraint(NSLayoutConstraint(item: moneySavedTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: moneySavedTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: sectionLeftPadding))
        
        savingsView.addSubview(fuelSavedTitleLabel)
        addConstraint(NSLayoutConstraint(item: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: viewElementVerticleMargin))
        addConstraint(NSLayoutConstraint(item: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: moneySavedTitleLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        savingsView.addSubview(co2SavedTitleLabel)
        addConstraint(NSLayoutConstraint(item: co2SavedTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: co2SavedLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: viewElementVerticleMargin))
        addConstraint(NSLayoutConstraint(item: co2SavedTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: co2SavedTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

        let savingsHeadingLabel = UILabel()
        savingsHeadingLabel.font = CaStyle.TripSummarySectionHeadingFont
        savingsHeadingLabel.text = "Savings"
        savingsHeadingLabel.textAlignment = NSTextAlignment.Center
        savingsHeadingLabel.textColor = CaStyle.TripSummarySavingsTitleColor
        savingsHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        savingsView.addSubview(savingsHeadingLabel)
        addConstraint(NSLayoutConstraint(item: savingsHeadingLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedLabel, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: (viewElementVerticleMargin * -1.0)))
        addConstraint(NSLayoutConstraint(item: savingsHeadingLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: savingsView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: savingsHeadingLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: savingsView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        
        
        // Map Section
        
        let mapAreaView = showMap ? mapView! : noMapView!
        if !showMap {
            let noMapLabel = UILabel()
            noMapLabel.font = CaStyle.TripSummarySectionHeadingFont
            noMapLabel.numberOfLines = 0
            noMapLabel.text = "This trip was entered manually."
            noMapLabel.textAlignment = NSTextAlignment.Center
            noMapLabel.textColor = UIColor.whiteColor()
            noMapLabel.translatesAutoresizingMaskIntoConstraints = false
            mapAreaView.addSubview(noMapLabel)
            mapAreaView.addConstraint(NSLayoutConstraint(item: noMapLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: mapAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -20))
            mapAreaView.addConstraint(NSLayoutConstraint(item: noMapLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: mapAreaView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
            mapAreaView.addConstraint(NSLayoutConstraint(item: noMapLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: mapAreaView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
            
        }
        
        addSubview(mapAreaView)
        addConstraint(NSLayoutConstraint(item: mapAreaView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: savingsView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: mapAreaView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: mapAreaView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: mapAreaView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
       
    }
}
