import UIKit

class ReputationController: UIViewController {
    
    var pointsView: PointsView!
    var milestonesView: MilestonesView!
    var milestonesLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        constructView()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        pointsView.points = CaDataManager.instance.fetchReputation()
        pointsView.weekAgoPoints = CaDataManager.instance.fetchWeekAgoReputation()
    }
    
    func constructView() {
        
        pointsView = PointsView()
        pointsView.translatesAutoresizingMaskIntoConstraints = false
        
        milestonesLayout = UICollectionViewFlowLayout()
        
        milestonesView = MilestonesView(frame: self.view.frame, collectionViewLayout: milestonesLayout)
        milestonesView.translatesAutoresizingMaskIntoConstraints = false
        milestonesView.registerClass(MilestoneCell.self, forCellWithReuseIdentifier: "MilestoneCell")
        milestonesView.dataSource = self
        milestonesView.delegate = self
        
        navigationController?.navigationBar.barTintColor = CaStyle.NavBarBgTintColor
        navigationController?.navigationBar.tintColor = CaStyle.NavBarTintColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: CaStyle.NavBarTitleColor]
        
        view.addSubview(pointsView)
        view.addConstraint(NSLayoutConstraint(item: pointsView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: pointsView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 120))
        view.addConstraint(NSLayoutConstraint(item: pointsView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: pointsView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
        view.addSubview(milestonesView)
        view.addConstraint(NSLayoutConstraint(item: milestonesView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: pointsView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: milestonesView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.bottomLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: milestonesView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: milestonesView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        
//        milestonesView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 0)
//        milestonesView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor, constant: 0)
        
    }
}

extension ReputationController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MilestoneCalculator.milestones.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MilestoneCell", forIndexPath: indexPath) as! MilestoneCell
        cell.milestoneImageView.image = UIImage(named: "rep-star")
        cell.milestoneTitle.text = MilestoneCalculator.milestones[indexPath.row].milestone.title
        return cell
    }

}

// TODO: Remove! This is never called!!!!

extension ReputationController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size: Int = Int((milestonesView.frame.width - (10*4)) / 3)
        return CGSize(width: size, height: size)
    }
}
