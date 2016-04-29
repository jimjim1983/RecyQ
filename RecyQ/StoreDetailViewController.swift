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
    var coupon: Coupon?
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var logo: UIImageView!
    @IBOutlet weak var redeemButton: UIButton!
    
    let ref = Firebase(url: "https://recyqdb.firebaseio.com/clients")
    let couponsRef = Firebase(url: "https://recyqdb.firebaseio.com/coupons")
    
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
            }
            
            alertController.addAction(cancelAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            
            let alertControllerAreYouSure = UIAlertController(title: "Weet u het zeker?", message: "Druk op OK om te bevestigen.", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Annuleer", style: .Cancel) { (action) in
            }
            
            let okayAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
                self.createCoupon()
                
                self.addSpentCoins()
                
                let alertGefeliciteerd = UIAlertController(title: "Gefeliciteerd!", message: "Uw aankoop is geslaagd. Ga naar de profiel pagina om uw coupons te bekijken.", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Terug", style: .Cancel) { (action) in
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
            
            }
    }
    
    func addSpentCoins() {
        
        ref.observeAuthEventWithBlock { authData in
            if self.ref.authData != nil {
                
                self.ref.queryOrderedByChild("uid").queryEqualToValue(self.ref.authData.uid).observeEventType(.ChildAdded, withBlock: { snapshot in
                    
                    let startingSpentCoinsAmount = snapshot.value.objectForKey("spentCoins") as? Int
                    
                   let endingSpentCoinsAmount = startingSpentCoinsAmount! + self.storeItem.storeItemPrice!
                    
                    if let name = user?.name {
                        let clientRef = Firebase(url: "https://recyqdb.firebaseio.com/clients/\(name)")
                        
                        clientRef.childByAppendingPath("spentCoins").setValue(endingSpentCoinsAmount)
                        
                        let totalWasteAmount =  user!.amountOfPlastic! + user!.amountOfPaper! + user!.amountOfTextile! + user!.amountOfIron! + user!.amountOfEWaste! + user!.amountOfBioWaste!
                        
                        let tokenAmount = round(totalWasteAmount/35)
                        
                        numberOfTokens = (Int(tokenAmount))  - (endingSpentCoinsAmount)
                    }
                    
                })}}}
    
    
    func createCoupon() {
        let uuid = NSUUID().UUIDString
        coupon = Coupon(uid: (user?.uid)!, couponName: storeItem.storeItemName!, couponValue: storeItem.storeItemPrice!, redeemed: false)
        
        let couponsRef = self.couponsRef.childByAppendingPath(uuid)
        couponsRef.setValue(self.coupon!.toAnyObject())
    }
  
}
