//
//  StoreDetailViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase

class StoreDetailViewController: UIViewController {
    
    var storeItem: StoreItem!
    
    @IBOutlet weak var price: UILabel!
    
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
        
        if let tokensPrice = storeItem.storeItemPrice {
        price.text = "Cost: \(tokensPrice) tokens"
        }
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Terug", style: UIBarButtonItemStyle.Plain, target: self, action: "navigateBack")
        
        self.navigationItem.title = "Redeem"
    }
    
    func navigateBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func redeemToken(sender: UIButton) {
        
        if storeItem.storeItemPrice > numberOfTokens {
            
            
            let alertController = UIAlertController(title: "U heeft niet genoeg tokens!", message: "Lever meer recyclebaar afval in om tokens te verdienen.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Annuleer", style: .Cancel) { (action) in
                // ...
            }
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)

        } else {
            
            let alertControllerAreYouSure = UIAlertController(title: "Weet u het zeker?", message: "Druk op OK om te bevestigen.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Annuleer", style: .Cancel) { (action) in
                // ...
            }
            
            let okayAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
                let alertGefeliciteerd = UIAlertController(title: "Gefeliciteerd!", message: "Uw aankoop is geslaagd. Ga naar de profiel pagina om uw coupons te bekijken.", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Annuleer", style: .Cancel) { (action) in
                    // ...
                }
                
               
                
                let goToProfielView = UIAlertAction(title: "Profiel", style: .Default) { (action) in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window?.rootViewController = appDelegate.tabbarController
                    appDelegate.tabbarController?.selectedIndex = 3
                }
                
                alertGefeliciteerd.addAction(cancelAction)
                alertGefeliciteerd.addAction(goToProfielView)
                 self.presentViewController(alertGefeliciteerd, animated: true, completion: nil)

            }
            alertControllerAreYouSure.addAction(cancelAction)
            alertControllerAreYouSure.addAction(okayAction)
            
            self.presentViewController(alertControllerAreYouSure, animated: true, completion: nil)
        
        if let name = user?.name {
        
        let ref = Firebase(url: "https://recyqdb.firebaseio.com/clients/\(name)")
            let newTokensSpentAmount = user!.spentCoins + storeItem.storeItemPrice!
            ref.childByAppendingPath("spentCoins").setValue(newTokensSpentAmount)
            }}
        
        
        
        //update spent tokens for user on backend
        //
        
//    let statsViewController = StatsViewController()
//    var startNumberOfTokens = statsViewController.testUser.amountOfTokens
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
