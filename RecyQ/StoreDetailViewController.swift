//
//  StoreDetailViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


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
        
        redeemButton.layer.cornerRadius = 10
      
        titleLabel.text = storeItem.storeItemName
        descriptionLabel.text = storeItem.storeItemDescription
//        descriptionLabel.numberOfLines = 0
        image.image = storeItem.storeItemImage
        
        if let tokensPrice = storeItem.storeItemPrice {
            if tokensPrice > 1 {
        price.text = "Prijs: \(tokensPrice) tokens"
            } else {
                price.text = "Prijs: \(tokensPrice) token"
            }
        }
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Terug", style: UIBarButtonItemStyle.plain, target: self, action: #selector(StoreDetailViewController.navigateBack))
        
        self.navigationItem.title = "Wissel in"
    }
    
    func navigateBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func redeemToken(_ sender: UIButton) {
            
       reachability = Reachability.init()
            
            reachability!.whenReachable = { reachability in
                // this is called on a background thread, but UI updates must
                // be on the main thread, like this:
                DispatchQueue.main.async {
                    
                    // added || numberOfTokens <= 0 because sometimes info on backend isn't updated in time to prevent a negative balance. TODO: Find another fix for this.
                    
                    // follow-up: I think the issue is actually the numberOfTokens that we use for calculation here is a global variable from the StatsVC. Thus that's the reason why this number isn't getting updated properly and sometimes leads to a negative balance? Still need to think this through a bit more and troubleshoot.
                    
                    if self.storeItem.storeItemPrice > numberOfTokens || numberOfTokens <= 0 {
                        
                        
                        let alertController = UIAlertController(title: "U heeft niet genoeg tokens!", message: "Lever meer recyclebaar afval in om tokens te verdienen.", preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "Annuleer", style: .cancel) { (action) in
                        }
                        
                        alertController.addAction(cancelAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                        
                    } else {
                        
                        let alertControllerAreYouSure = UIAlertController(title: "Weet u het zeker?", message: "Druk op OK om te bevestigen.", preferredStyle: .alert)
                        
                        let cancelAction = UIAlertAction(title: "Annuleer", style: .cancel) { (action) in
                        }
                        
                        let okayAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            
                            self.createCoupon()
                            
                            self.addSpentCoins()
                            
                            let alertGefeliciteerd = UIAlertController(title: "Gefeliciteerd!", message: "Uw aankoop is geslaagd. Ga naar de profiel pagina om uw coupons te bekijken.", preferredStyle: .alert)
                            
                            let cancelAction = UIAlertAction(title: "Terug", style: .cancel) { (action) in
                                // ...
                            }
                            
                            let goToProfielView = UIAlertAction(title: "Profiel", style: .default) { (action) in
                                
                                self.dismiss(animated: true, completion: nil)
                                
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.window?.rootViewController = appDelegate.tabbarController
                                appDelegate.tabbarController?.selectedIndex = 3
                            }
                            
                            alertGefeliciteerd.addAction(cancelAction)
                            alertGefeliciteerd.addAction(goToProfielView)
                            self.present(alertGefeliciteerd, animated: true, completion: nil)
                            
                        }
                        alertControllerAreYouSure.addAction(cancelAction)
                        alertControllerAreYouSure.addAction(okayAction)
                        
                        self.present(alertControllerAreYouSure, animated: true, completion: nil)
                        
                    }

//                    if reachability.isReachableViaWiFi() {
//                        print("Reachable via WiFi")
//                    } else {
//                        print("Reachable via Cellular")
//                    }
                }
            }
            
            reachability!.whenUnreachable = { reachability in
                // this is called on a background thread, but UI updates must
                // be on the main thread, like this:
                DispatchQueue.main.async {
                    print("Not reachable")
                    
                    let alert = UIAlertController(title: "Oeps!", message: "Please connect to the internet to use the RecyQ app.", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) -> Void in
                    }
                    alert.addAction(okayAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            }
            
            do {
                try reachability!.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
        


        //couponItems.removeAll()
           }
    
    func addSpentCoins() {
        
        ref?.observeAuthEvent { authData in
            if self.ref?.authData != nil {
                
                self.ref?.queryOrdered(byChild: "uid").queryEqual(toValue: self.ref?.authData.uid).observe(.childAdded, with: { snapshot in
                    
                    let startingSpentCoinsAmount = (snapshot?.value as AnyObject).object(forKey: "spentCoins") as? Int
                    
                   let endingSpentCoinsAmount = startingSpentCoinsAmount! + self.storeItem.storeItemPrice!
                    
                    if let name = user?.name {
                        let clientRef = Firebase(url: "https://recyqdb.firebaseio.com/clients/\(name)")
                        
                        clientRef?.child(byAppendingPath: "spentCoins").setValue(endingSpentCoinsAmount)
                        
                        let totalWasteAmount =  user!.amountOfPlastic! + user!.amountOfPaper! + user!.amountOfTextile! + user!.amountOfIron! + user!.amountOfEWaste! + user!.amountOfBioWaste!
                        
                        let tokenAmount = round(totalWasteAmount/35)
                        
                        numberOfTokens = (Int(tokenAmount))  - (endingSpentCoinsAmount)
                    }
                    
                })}}}
    
    
    func createCoupon() {
        
        let uuid = UUID().uuidString
        
        coupon = Coupon(uid: (user?.uid)!, couponName: storeItem.storeItemName!, couponValue: storeItem.storeItemPrice!, redeemed: false)
        
        let couponsRef = self.couponsRef?.child(byAppendingPath: storeItem.storeItemName! + uuid)
        couponsRef?.setValue(self.coupon!.toAnyObject())
    }
  
}



