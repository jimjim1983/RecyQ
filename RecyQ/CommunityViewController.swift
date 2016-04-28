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
    
    @IBOutlet weak var co2TotalLabel: UILabel!
  
    @IBOutlet weak var recyclingTotalLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var communityFundImageView: UIImageView!
    
    @IBOutlet weak var communityCO2BarImageView: UIImageView!
    
    
    @IBOutlet weak var communityRecyclingImageView: UIImageView!
    
    

    
    
    override func viewDidLayoutSubviews()
    {
        let scrollViewBounds = scrollView.bounds
        let containerViewBounds = contentView.bounds
        
        var scrollViewInsets = UIEdgeInsetsZero
        scrollViewInsets.top = scrollViewBounds.size.height
        scrollViewInsets.top -= containerViewBounds.size.height

        scrollViewInsets.bottom = scrollViewBounds.size.height
        scrollViewInsets.bottom -= containerViewBounds.size.height
        scrollViewInsets.bottom += 1

        scrollView.contentInset = UIEdgeInsetsMake(0.0,0.0,150.0,0.0)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    @IBAction func leaderboardButtonPressed(sender: UIButton) {
        
        let leaderboardVC = LeaderboardViewController()
        
        self.presentViewController(leaderboardVC, animated: true, completion: nil)
        
    }
    
    @IBAction func partnersButtonPressed(sender: UIButton) {
        
        print("community button pressed")
        
        let partnersVC = PartnersViewController()
        
        self.presentViewController(partnersVC, animated: true, completion: nil)
    }
    
    // having weird issue with partnersButtonPressed not being called, so I created a button outside the scroll view and set it over the heart button in the .xib
 
    @IBAction func buttonPressed(sender: AnyObject) {
        
        let partnersVC = PartnersViewController()
        
        self.presentViewController(partnersVC, animated: true, completion: nil)
    }
    
}
