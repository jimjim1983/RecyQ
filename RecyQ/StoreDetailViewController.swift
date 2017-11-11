//
//  StoreDetailViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth
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
    
    @IBOutlet var shopNameLabel: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var redeemButton: UIButton!
    
    var shop: Shop!
    var coupon: Coupon?
    var numberOfTokens: Int?
    
    let ref = FIRDatabase.database().reference(withPath: "clients")
    let couponsRef = FIRDatabase.database().reference(withPath: "coupons")
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wissel in"
        self.image.addBorderWith(width: 1, color: .darkGray)
        
        self.shopNameLabel.text = " " + self.shop.shopName
        self.titleLabel.text = self.shop.itemName
        self.descriptionLabel.text = self.shop.detailDescription
        let imageString = shop.imageString
        if let imageData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters) {
            self.image.image = UIImage(data: imageData)
        }
        
        let tokensPrice = self.shop.tokenAmount
        if tokensPrice > 1 {
            price.text = "Prijs: \(tokensPrice) tokens"
        } else {
            price.text = "Prijs: \(tokensPrice) token"
        }
    }

    @IBAction func redeemToken(_ sender: UIButton) {
        
        reachability = Reachability.init()
        
        reachability!.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                
                // added || numberOfTokens <= 0 because sometimes info on backend isn't updated in time to prevent a negative balance. TODO: Find another fix for this.
                
                // follow-up: I think the issue is actually the numberOfTokens that we use for calculation here is a global variable from the StatsVC. Thus that's the reason why this number isn't getting updated properly and sometimes leads to a negative balance? Still need to think this through a bit more and troubleshoot.
                
                if let numberOfTokens = self.numberOfTokens {
                    if self.shop.tokenAmount > numberOfTokens || numberOfTokens <= 0 {
                        
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
                            self.addSpentTokens()
                            let alertGefeliciteerd = UIAlertController(title: "Gefeliciteerd!", message: "Uw aankoop is geslaagd. Ga naar de profiel pagina om uw coupons te bekijken.", preferredStyle: .alert)
                            
                            let cancelAction = UIAlertAction(title: "Terug", style: .cancel) { (action) in
                                _ = self.navigationController?.popViewController(animated: true)                                }
                            alertGefeliciteerd.addAction(cancelAction)
                            self.present(alertGefeliciteerd, animated: true, completion: nil)
                        }
                        alertControllerAreYouSure.addAction(cancelAction)
                        alertControllerAreYouSure.addAction(okayAction)
                        
                        self.present(alertControllerAreYouSure, animated: true, completion: nil)
                        
                    }
                }
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
    
    func addSpentTokens() {
        if let currentUser = FIRAuth.auth()?.currentUser {
            FirebaseHelper.References.clientsRef.queryOrdered(byChild: "uid").queryEqual(toValue: currentUser.uid).observe(.childAdded, with: { (snapshot) in
        
                 let user = User(snapshot: snapshot)
                    if let startingSpentCoinsAmount = user.spentCoins {
                        let endingSpentCoinsAmount = startingSpentCoinsAmount + self.shop.tokenAmount
                        FirebaseHelper.References.clientsRef.child(user.uid).child("spentCoins").setValue(endingSpentCoinsAmount)
                    }
            })
        }
    }    
    
    func createCoupon() {
        let couponUID = UUID().uuidString
        let cureentUserUID = FIRAuth.auth()?.currentUser?.uid
        
        self.coupon = Coupon(uid: couponUID, ownerID: cureentUserUID!, shopName: self.shop.shopName, validationCode: self.shop.validationCode, couponName: self.shop.itemName, couponValue: self.shop.tokenAmount, redemeed: false, dateCreated: self.dateFormatter.string(from: Date()), dateRedeemd: nil)
        
        let newCouponKey = couponUID
        let newCouponRef = FirebaseHelper.References.couponsRef.child(newCouponKey)
        
        if let coupon = self.coupon {
            newCouponRef.setValue(coupon.toAnyObject())
        }
    }
}
