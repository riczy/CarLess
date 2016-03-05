import UIKit

class CaLogManualTripView: UIView {
    
    // MARK: - UI Properties
    
    var headingView = UIView()
    var headingLabel = UILabel()
    var distanceLabel = UILabel()
    var distanceTextField = UITextField()
    var timestampLabel = UILabel()
    var timestampTextField = UITextField()
    var modeLabel = UILabel()
    var modeTextField = UITextField()
    var categoryLabel = UILabel()
    var categoryTextField = UITextField()
    var saveButton = CaComponent.createButton(title: "Save trip", color: CaStyle.LogSaveButtonColor, bgColor: CaStyle.LogSaveButtonBgColor, borderColor: CaStyle.LogSaveButtonBorderColor)
    
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
        
        let alignment = NSTextAlignment.Center
        backgroundColor = CaStyle.ViewBgColor
        
        headingView.translatesAutoresizingMaskIntoConstraints = false
        headingView.backgroundColor = CaStyle.LogHeadlineBgColor
        
        headingLabel.font = CaStyle.InstructionHeadlineFont
        headingLabel.numberOfLines = 0
        headingLabel.text = "Enter your trip and save"
        headingLabel.textAlignment = NSTextAlignment.Center
        headingLabel.textColor = CaStyle.LogHeadlineColor
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timestampLabel.font = CaStyle.InputLabelFont
        timestampLabel.text = "Start date and time"
        timestampLabel.textAlignment = alignment
        timestampLabel.textColor = CaStyle.InputLabelColor
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        
        timestampTextField.adjustsFontSizeToFitWidth = true
        timestampTextField.borderStyle = UITextBorderStyle.None
        timestampTextField.font = CaStyle.InputFieldFont
        timestampTextField.minimumFontSize = CaStyle.InputFieldFontMinimumScaleFactor
        timestampTextField.placeholder = "Start date and time"
        timestampTextField.textAlignment = alignment
        timestampTextField.textColor = CaStyle.InputFieldColor
        timestampTextField.translatesAutoresizingMaskIntoConstraints = false
        
        modeLabel.font = CaStyle.InputLabelFont
        modeLabel.text = "Transportation"
        modeLabel.textAlignment = alignment
        modeLabel.textColor = CaStyle.InputLabelColor
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        modeTextField.adjustsFontSizeToFitWidth = true
        modeTextField.borderStyle = UITextBorderStyle.None
        modeTextField.font = CaStyle.InputFieldFont
        modeTextField.minimumFontSize = CaStyle.InputFieldFontMinimumScaleFactor
        modeTextField.placeholder = "Transportation"
        modeTextField.textAlignment = alignment
        modeTextField.textColor = CaStyle.InputFieldColor
        modeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        distanceLabel.font = CaStyle.InputLabelFont
        distanceLabel.text = "Distance"
        distanceLabel.textAlignment = alignment
        distanceLabel.textColor = CaStyle.InputLabelColor
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        distanceTextField.adjustsFontSizeToFitWidth = true
        distanceTextField.borderStyle = UITextBorderStyle.None
        distanceTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        distanceTextField.font = CaStyle.InputFieldFont
        distanceTextField.keyboardType = UIKeyboardType.DecimalPad
        distanceTextField.minimumFontSize = CaStyle.InputFieldFontMinimumScaleFactor
        distanceTextField.placeholder = "0.0"
        distanceTextField.textAlignment = alignment
        distanceTextField.textColor = CaStyle.InputFieldColor
        distanceTextField.translatesAutoresizingMaskIntoConstraints = false
        
        categoryLabel.font = CaStyle.InputLabelFont
        categoryLabel.text = "Category"
        categoryLabel.textAlignment = alignment
        categoryLabel.textColor = CaStyle.InputLabelColor
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryTextField.adjustsFontSizeToFitWidth = true
        categoryTextField.borderStyle = UITextBorderStyle.None
        categoryTextField.font = CaStyle.InputFieldFont
        categoryTextField.minimumFontSize = CaStyle.InputFieldFontMinimumScaleFactor
        categoryTextField.placeholder = "The purpose of your trip"
        categoryTextField.textAlignment = alignment
        categoryTextField.textColor = CaStyle.InputFieldColor
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
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
        
        addSubview(timestampLabel)
        addConstraint(NSLayoutConstraint(item: timestampLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: headingView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupVerticlePadding))
        addConstraint(NSLayoutConstraint(item: timestampLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: timestampLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        addSubview(timestampTextField)
        addConstraint(NSLayoutConstraint(item: timestampTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: timestampLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupLvVerticlePadding))
        addConstraint(NSLayoutConstraint(item: timestampTextField, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: timestampTextField, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))

        addSubview(modeLabel)
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: timestampTextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupVerticlePadding))
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: modeLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        addSubview(modeTextField)
        addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupLvVerticlePadding))
        addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: modeTextField, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        addSubview(distanceLabel)
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: modeTextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupVerticlePadding))
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: distanceLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        addSubview(distanceTextField)
        addConstraint(NSLayoutConstraint(item: distanceTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: distanceLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupLvVerticlePadding))
        addConstraint(NSLayoutConstraint(item: distanceTextField, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: distanceTextField, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))

        
        addSubview(categoryLabel)
        addConstraint(NSLayoutConstraint(item: categoryLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: distanceTextField, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupVerticlePadding))
        addConstraint(NSLayoutConstraint(item: categoryLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: categoryLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))
        
        addSubview(categoryTextField)
        addConstraint(NSLayoutConstraint(item: categoryTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: categoryLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupLvVerticlePadding))
        addConstraint(NSLayoutConstraint(item: categoryTextField, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 20.0))
        addConstraint(NSLayoutConstraint(item: categoryTextField, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: -20.0))

        
        addSubview(saveButton)
        addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: CaStyle.InputGroupVerticlePadding * -1))
        addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonWidth))
        addConstraint(NSLayoutConstraint(item: saveButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: CaStyle.ButtonHeight))
        
    }


}
