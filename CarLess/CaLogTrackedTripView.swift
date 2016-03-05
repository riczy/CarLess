import UIKit

class CaLogTrackedTripView: UIView {
    
    // MARK: - UI Properties
    
    var headingView = UIView()
    var headingLabel = UILabel()
    var modeLabel = UILabel()
    var modeTextField = UITextField()
    var categoryLabel = UILabel()
    var categoryTextField = UITextField()
    var startButton = CaComponent.createButton(title: "Start tracking", color: CaStyle.LogStartButtonColor, bgColor: CaStyle.LogStartButtonBgColor, borderColor: CaStyle.LogStartButtonBorderColor)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }

    private func initComponents() {
        
        backgroundColor = CaStyle.ViewBgColor
        
        headingView.translatesAutoresizingMaskIntoConstraints = false
        headingView.backgroundColor = CaStyle.LogHeadlineBgColor
        
        headingLabel.font = CaStyle.InstructionHeadlineFont
        headingLabel.numberOfLines = 0
        headingLabel.text = "Choose your transportation and start tracking"
        headingLabel.textAlignment = NSTextAlignment.Center
        headingLabel.textColor = CaStyle.LogHeadlineColor
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        modeLabel.font = CaStyle.InputLabelFont
        modeLabel.text = "Transportation"
        modeLabel.textAlignment = NSTextAlignment.Center
        modeLabel.textColor = CaStyle.InputLabelColor
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        modeTextField.adjustsFontSizeToFitWidth = true
        modeTextField.borderStyle = UITextBorderStyle.None
        modeTextField.font = CaStyle.InputFieldFont
        modeTextField.minimumFontSize = CaStyle.InputFieldFontMinimumScaleFactor
        modeTextField.placeholder = "Mode"
        modeTextField.textAlignment = NSTextAlignment.Center
        modeTextField.textColor = CaStyle.InputFieldColor
        modeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        categoryLabel.font = CaStyle.InputLabelFont
        categoryLabel.text = "Category"
        categoryLabel.textAlignment = NSTextAlignment.Center
        categoryLabel.textColor = CaStyle.InputLabelColor
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryTextField.adjustsFontSizeToFitWidth = true
        categoryTextField.borderStyle = UITextBorderStyle.None
        categoryTextField.font = CaStyle.InputFieldFont
        categoryTextField.minimumFontSize = CaStyle.InputFieldFontMinimumScaleFactor
        categoryTextField.placeholder = "The purpose of your trip"
        categoryTextField.textAlignment = NSTextAlignment.Center
        categoryTextField.textColor = CaStyle.InputFieldColor
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
   }
    
    private func setConstraints() {
        
        let instructionHeight : CGFloat = frame.height * 0.3
        
        addSubview(headingView)
        addConstraint(NSLayoutConstraint(item: headingView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: headingView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: headingView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: headingView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: instructionHeight))
        
        headingView.addSubview(headingLabel)
        headingView.addConstraint(NSLayoutConstraint(item: headingLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: headingView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        headingView.addConstraint(NSLayoutConstraint(item: headingLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: headingView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        headingView.addConstraint(NSLayoutConstraint(item: headingLabel, attribute: .Left, relatedBy: .Equal, toItem: headingView, attribute: .Left, multiplier: 1.0, constant: 30))
        headingView.addConstraint(NSLayoutConstraint(item: headingLabel, attribute: .Right, relatedBy: .Equal, toItem: headingView, attribute: .Right, multiplier: 1.0, constant: -30))
        
        addSubview(modeLabel)
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: headingView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupVerticlePadding))
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        addSubview(modeTextField)
        addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupLvVerticlePadding))
        addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        addSubview(categoryLabel)
        addConstraint(NSLayoutConstraint(item: categoryLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeTextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupVerticlePadding))
        addConstraint(NSLayoutConstraint(item: categoryLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: categoryLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        addSubview(categoryTextField)
        addConstraint(NSLayoutConstraint(item: categoryTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: categoryLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupLvVerticlePadding))
        addConstraint(NSLayoutConstraint(item: categoryTextField, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: categoryTextField, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        addSubview(startButton)
        addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupVerticlePadding * -1))
        addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonWidth))
        addConstraint(NSLayoutConstraint(item: startButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonHeight))
    }

}
