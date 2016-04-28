//
//  CommunityViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 3/29/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase

class CommunityViewController: UIViewController {
    
    @IBOutlet var communityCounterLabel: UILabel!

//    @IBOutlet var tableView: UITableView!
    
  
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var communityFundImageView: UIImageView!
    
    @IBOutlet weak var communityCO2BarImageView: UIImageView!
    
    
    @IBOutlet weak var communityRecyclingImageView: UIImageView!
    
    
    // Test users for the leaderboards
    var userArray = [User]()
    var testUser1 = User(name: "Jim", addedByUser: "Recyq", completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: "0", spentCoins: 0)
    var testUser2 = User(name: "Alyson", addedByUser: "Recyq", completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: "0", spentCoins: 0)
    
    
    override func viewDidLayoutSubviews()
    {
        let scrollViewBounds = scrollView.bounds
        let containerViewBounds = contentView.bounds
//
        var scrollViewInsets = UIEdgeInsetsZero
        scrollViewInsets.top = scrollViewBounds.size.height
        scrollViewInsets.top -= containerViewBounds.size.height

        scrollViewInsets.bottom = scrollViewBounds.size.height
        scrollViewInsets.bottom -= containerViewBounds.size.height
        scrollViewInsets.bottom += 1
        
//        scrollView.contentInset = scrollViewInsets
        
//        scrollView.contentSize = CGSizeMake(contentView.bounds.width, contentView.bounds.height)

        
//        scrollView.contentSize = CGSizeMake(320,758)
        scrollView.contentInset = UIEdgeInsetsMake(0.0,0.0,150.0,0.0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        userArray = [testUser1,testUser2]
        userArray.sortInPlace({$1.amountOfPlastic < $0.amountOfPlastic})
        
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.allowsSelection = false
//        tableView.backgroundColor = UIColor(red: 33/255, green: 210/255, blue: 37/255, alpha: 1.0)
//        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
//        
////        communityCounterImageView.image = UIImage(named: "communityCounter")
//        
//        let nib = UINib.init(nibName: "CommunityTableViewCell", bundle: nil)
//        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        
        scrollView.setContentOffset(CGPointMake(0,0), animated: true)
        
        let couponsRef = Firebase(url: "https://recyqdb.firebaseio.com/coupons")
        
        var eurosCount: Int?
        
        couponsRef.queryOrderedByChild("couponName").queryEqualToValue("Doneer aan het Buurtafvalfonds").observeEventType(.Value, withBlock: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
               eurosCount = snapshots.count
                print(snapshots)
                print(eurosCount)
                
                if let communityEuros = eurosCount {
                
                self.communityCounterLabel.text = "€\(communityEuros)"
                } else {
                    self.communityCounterLabel.text = "€0"
                }
            }
        })
        
        communityFundImageView.alpha = 0
        communityCO2BarImageView.alpha = 0
        communityRecyclingImageView.alpha = 0
        
        slideCommunityFundView()
        
        NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "slideCO2BarView", userInfo: nil, repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "slideCommunityRecyclingView", userInfo: nil, repeats: false)
        
    }
    
    func slideCommunityFundView() {
        addSlideAnimation(communityFundImageView)
    }
    
    func slideCO2BarView() {
        addSlideAnimation(communityCO2BarImageView)
    }
    
    func slideCommunityRecyclingView() {
        addSlideAnimation(communityRecyclingImageView)
    }
    
    func addSlideAnimation(viewName: UIView) {
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -500
        animation.toValue = 0
        animation.duration = 1
        animation.autoreverses = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        viewName.layer.addAnimation(animation, forKey: nil)
        viewName.alpha = 1
    }


    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return userArray.count
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 22
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CommunityTableViewCell
//        
//        let user = userArray[indexPath.row]
//        cell.nameLabel.text = user.name
//        
//        //change amountOfPlastic to co2 saved calculation
//        if let co2Saved = user.amountOfPlastic {
//            cell.co2SavedLabel.text = "\(co2Saved)"
//        }
//        return cell
//    }


    
    
    
    
}
