import UIKit

class ReputationView: UIView {

    // MARK: - UI Properties
    private var pointsLabel = UILabel()
    private var _points = 0
    var points: Int {
        get {
            return _points
        }
        set(points) {
            _points = points
            setPointsLabelText()
        }
    }
    private var weekAgoPointsLabel = UILabel()
    private var _weekAgoPoints = 0
    var weekAgoPoints: Int {
        get {
            return _weekAgoPoints
        }
        set(points) {
            _weekAgoPoints = points
            setWeekAgoPointsLabelText()
        }
    }
    
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

        setPointsLabelText()
        setWeekAgoPointsLabelText()
        
        pointsLabel.textAlignment = NSTextAlignment.Center
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        weekAgoPointsLabel.textAlignment = NSTextAlignment.Center
        weekAgoPointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setPointsLabelText() {
        
        let text = "\(points) POINTS" as NSString
        let attrText = NSMutableAttributedString(string: text as String)
        let numberAttrDict = [
            NSForegroundColorAttributeName: CaStyle.RepPointsLabelColor,
            NSFontAttributeName: UIFont.boldSystemFontOfSize(48)
        ]
        let labelAttrDict = [
            NSForegroundColorAttributeName: CaStyle.RepPointsLabelColor,
            NSFontAttributeName: UIFont.systemFontOfSize(10)
        ]
        
        attrText.addAttributes(numberAttrDict, range: text.rangeOfString("\(points)"))
        attrText.addAttributes(labelAttrDict, range: text.rangeOfString("POINTS"))
        
        pointsLabel.attributedText = attrText
    }
    
    func setWeekAgoPointsLabelText() {
        
        let pointsDiff = points - weekAgoPoints
        if pointsDiff > 0 {
            
            let numberText = " +\(pointsDiff) "
            let labelText = " in the past week"
            let text = (numberText + labelText) as NSString
            let attrText = NSMutableAttributedString(string: text as String)
            let numberAttrDict = [
                NSForegroundColorAttributeName: CaStyle.RepPointsSectionBgColor,
                NSBackgroundColorAttributeName: CaStyle.RepPointsLabelColor,
                NSFontAttributeName: UIFont.boldSystemFontOfSize(12)
            ]
            let labelAttrDict = [
                NSForegroundColorAttributeName: CaStyle.RepPointsLabelColor,
                NSFontAttributeName: UIFont.systemFontOfSize(12)
            ]
            attrText.addAttributes(numberAttrDict, range: text.rangeOfString(numberText))
            attrText.addAttributes(labelAttrDict, range: text.rangeOfString(labelText))
            weekAgoPointsLabel.attributedText = attrText
        } else {
            weekAgoPointsLabel.text = nil
        }
    }
    
    private func setConstraints() {
        
        let pointsView = UIView()
        pointsView.backgroundColor = CaStyle.RepPointsSectionBgColor
        pointsView.translatesAutoresizingMaskIntoConstraints = false;
        addSubview(pointsView)
        addConstraint(NSLayoutConstraint(item: pointsView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: pointsView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: pointsView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: pointsView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 120))
        
        pointsView.addSubview(pointsLabel)
        addConstraint(NSLayoutConstraint(item: pointsLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: pointsView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -10))
        addConstraint(NSLayoutConstraint(item: pointsLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: pointsView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: pointsLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: pointsView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        
        pointsView.addSubview(weekAgoPointsLabel)
        addConstraint(NSLayoutConstraint(item: weekAgoPointsLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: pointsLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: weekAgoPointsLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: pointsView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: weekAgoPointsLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: pointsView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        

    }
    
}
