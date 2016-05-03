import UIKit

class MilestonesView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor.redColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MilestoneCell : UICollectionViewCell {
    
    var milestoneImageView = UIImageView()
    var milestoneTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initComponents() {
        backgroundColor = UIColor.blueColor()
        
        milestoneImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(milestoneImageView)
        
        milestoneTitle.translatesAutoresizingMaskIntoConstraints = false
        milestoneTitle.textAlignment = NSTextAlignment.Center
        milestoneTitle.font = CaStyle.RepMilestoneName
        
        contentView.addSubview(milestoneTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addConstraint(NSLayoutConstraint(item: milestoneImageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: milestoneImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: milestoneTitle, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: milestoneImageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: milestoneTitle, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: milestoneTitle, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: milestoneTitle, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

    }
    
  
}