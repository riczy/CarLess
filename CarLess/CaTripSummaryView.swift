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
        
        startTimestampLabel.font = valueTitleFont
        startTimestampLabel.textAlignment = NSTextAlignment.Center
        startTimestampLabel.textColor = CaStyle.InstructionHeadlineColor
        startTimestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        fuelSavedLabel.font = valueFont
        fuelSavedLabel.textAlignment = alignment
        fuelSavedLabel.textColor = CaStyle.InputFieldColor
        fuelSavedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        moneySavedLabel.font = valueFont
        moneySavedLabel.textAlignment = alignment
        moneySavedLabel.textColor = CaStyle.InputFieldColor
        moneySavedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        co2SavedLabel.font = valueFont
        co2SavedLabel.textAlignment = alignment
        co2SavedLabel.textColor = CaStyle.InputFieldColor
        co2SavedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        fuelSavedTitleLabel.font = valueTitleFont
        fuelSavedTitleLabel.text = "Fuel"
        fuelSavedTitleLabel.textAlignment = alignment
        fuelSavedTitleLabel.textColor = CaStyle.InputLabelColor
        fuelSavedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        moneySavedTitleLabel.font = valueTitleFont
        moneySavedTitleLabel.text = "Money"
        moneySavedTitleLabel.textAlignment = alignment
        moneySavedTitleLabel.textColor = CaStyle.InputLabelColor
        moneySavedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        co2SavedTitleLabel.font = valueTitleFont
        co2SavedTitleLabel.text = "CO\u{2082}"
        co2SavedTitleLabel.textAlignment = alignment
        co2SavedTitleLabel.textColor = CaStyle.InputLabelColor
        co2SavedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        distanceLabel.font = valueFont
        distanceLabel.textAlignment = alignment
        distanceLabel.textColor = CaStyle.InputFieldColor
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        modeLabel.font = valueTitleFont
        modeLabel.textAlignment = alignment
        modeLabel.textColor = CaStyle.InputFieldColor
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
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
    
        let sectionLeftPadding: CGFloat = 10
        let valueWidth: CGFloat = (frame.size.width - (sectionLeftPadding * 2)) / 3.0
        let valueTopMargin: CGFloat = 8
        let valueTitleTopMargin: CGFloat = 3
        
        addSubview(startTimestampLabel)
        addConstraint(NSLayoutConstraint(item: startTimestampLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 40))
        addConstraint(NSLayoutConstraint(item: startTimestampLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: startTimestampLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        addSubview(distanceLabel)
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: startTimestampLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTitleTopMargin))
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        addSubview(modeLabel)
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: distanceLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTitleTopMargin))
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        
        // Map Section
        
        let hrView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: CaStyle.InputFieldHrThickness))
        hrView.backgroundColor = CaStyle.InputFieldHrColor
        hrView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hrView)
        addConstraint(NSLayoutConstraint(item: hrView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: hrView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.InputFieldHrThickness))
        addConstraint(NSLayoutConstraint(item: hrView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: hrView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
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
        addConstraint(NSLayoutConstraint(item: mapAreaView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: hrView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: mapAreaView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: mapAreaView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: mapAreaView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 160))
        
        
        let hr2View = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: CaStyle.InputFieldHrThickness))
        hr2View.backgroundColor = CaStyle.InputFieldHrColor
        hr2View.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hr2View)
        addConstraint(NSLayoutConstraint(item: hr2View, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mapAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: hr2View, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.InputFieldHrThickness))
        addConstraint(NSLayoutConstraint(item: hr2View, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: hr2View, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        // Savings Section
        
        let savingsHeadingLabel = UILabel()
        savingsHeadingLabel.font = CaStyle.TripSummarySectionHeadingFont
        savingsHeadingLabel.text = "Savings"
        savingsHeadingLabel.textAlignment = NSTextAlignment.Center
        savingsHeadingLabel.textColor = CaStyle.TripSummarySectionHeadingColor
        savingsHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(savingsHeadingLabel)
        addConstraint(NSLayoutConstraint(item: savingsHeadingLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mapAreaView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: savingsHeadingLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: sectionLeftPadding))
        addConstraint(NSLayoutConstraint(item: savingsHeadingLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: (sectionLeftPadding * -1.0)))
        
        
        addSubview(moneySavedLabel)
        addConstraint(NSLayoutConstraint(item: moneySavedLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: savingsHeadingLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTopMargin))
        addConstraint(NSLayoutConstraint(item: moneySavedLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: moneySavedLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: sectionLeftPadding))
        
        addSubview(fuelSavedLabel)
        addConstraint(NSLayoutConstraint(item: fuelSavedLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: savingsHeadingLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTopMargin))
        addConstraint(NSLayoutConstraint(item: fuelSavedLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: fuelSavedLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: moneySavedLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        addSubview(co2SavedLabel)
        addConstraint(NSLayoutConstraint(item: co2SavedLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: savingsHeadingLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTopMargin))
        addConstraint(NSLayoutConstraint(item: co2SavedLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: co2SavedLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

        
        addSubview(moneySavedTitleLabel)
        addConstraint(NSLayoutConstraint(item: moneySavedTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: moneySavedLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTitleTopMargin))
        addConstraint(NSLayoutConstraint(item: moneySavedTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: moneySavedTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: sectionLeftPadding))
        
        addSubview(fuelSavedTitleLabel)
        addConstraint(NSLayoutConstraint(item: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTitleTopMargin))
        addConstraint(NSLayoutConstraint(item: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: moneySavedTitleLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        addSubview(co2SavedTitleLabel)
        addConstraint(NSLayoutConstraint(item: co2SavedTitleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: co2SavedLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: valueTitleTopMargin))
        addConstraint(NSLayoutConstraint(item: co2SavedTitleLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: valueWidth))
        addConstraint(NSLayoutConstraint(item: co2SavedTitleLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: fuelSavedTitleLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

    }
}
