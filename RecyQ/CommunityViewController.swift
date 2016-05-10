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
    
    var clientsRef = Firebase(url: "https://recyqdb.firebaseio.com/clients")
    
    var wasteArray = [Double]()
    
    
    
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
        
        //right now I only call getAmountOfWaste in the viewDidLoad instead of viewWillAppear because code will duplicate data every time in viewWillAppear unless you set the array to empty first in getAmountOfWaste
        
        getAmountOfWaste()
        
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
        
        print(wasteArray)
        
//        print("Hello \(setCo2TotalLabel())")
        
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
    
    func getAmountOfWaste() {
            
            // go trough all coupons and find the one with the same user uid, then add them to the array for the tableview
            self.clientsRef.queryOrderedByChild("amountOfBioWaste").observeEventType(.Value, withBlock: { snapshot in
            
                
                if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                    for item in snapshots {
                        let amountOfPlastic = item.value.objectForKey("amountOfPlastic") as? Double
                        let amountOfBioWaste = item.value.objectForKey("amountOfBioWaste") as? Double
                        let amountOfEWaste = item.value.objectForKey("amountOfEWaste") as? Double
                        let amountOfIron = item.value.objectForKey("amountOfIron") as? Double
                        let amountOfPaper = item.value.objectForKey("amountOfPaper") as? Double
                        let amountOfTextile = item.value.objectForKey("amountOfTextile") as? Double
                        self.wasteArray.append(amountOfPlastic!)
                        self.wasteArray.append(amountOfBioWaste!)
                        self.wasteArray.append(amountOfEWaste!)
                        self.wasteArray.append(amountOfIron!)
                        self.wasteArray.append(amountOfPaper!)
                        self.wasteArray.append(amountOfTextile!)
                    }
               
                }
                
                var total = Double()
                
                for i in self.wasteArray {
                    total = total + i
                }
                
                self.recyclingTotalLabel.text = "\(round(total)) kg"
                
                let co2Amount = (round((total/35) * 50))
                
                self.co2TotalLabel.text = "\(co2Amount) kg"
                
            
        })
    }
    
  
    @IBAction func leaderboardButtonPressed(sender: UIButton) {
        
        let leaderboardVC = LeaderboardViewController()
        
        self.presentViewController(leaderboardVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func infoButtonPressed(sender: UIButton) {
        
        let infoVC = InfoViewController()
        self.presentViewController(infoVC, animated: true, completion: nil)
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
