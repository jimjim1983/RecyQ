//
//  StoreDetailViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class StoreDetailViewController: UIViewController {
    
    var storeItem: StoreItem!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var logo: UIImageView!
    @IBOutlet weak var redeemButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        titleLabel.text = storeItem.storeItemName
        descriptionLabel.text = storeItem.storeItemDescription
        descriptionLabel.numberOfLines = 0
        image.image = storeItem.storeItemImage
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Terug", style: UIBarButtonItemStyle.Plain, target: self, action: "navigateBack")
    }
    
    func navigateBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func redeemToken(sender: UIButton) {
        
    let statsViewController = StatsViewController()
    var startNumberOfTokens = statsViewController.testUser.amountOfTokens
    // var subtractor = cost of item
    // var endNumberOfTokens = int
    // let endNumberOfTokens = startNumberOfTokens - subtractor
    //  statsViewController.testUser.amountOfTokens = endNumberOfTokens
    // code that goes to backend to show how many tokens were redeemed and for which product - should go to user and general coupon table item
    // code that goes to new custom pop up view that says token has been successfully redeemed.
    // option to see coupon in profile view controller
    // option to dismiss
    // redeem button restored? or back to store view controller?
    
    }
  
    
    
}
