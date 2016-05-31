//
//  StoreViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase


class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let ref = Firebase(url: "https://recyqdb.firebaseio.com/clients")

    var storeItemArray = [StoreItem]()
    
    var storeItem4 = StoreItem(storeItemName: "Upcycling boodschappentas gemaakt van denim", storeItemDescription: "Wissel je tokens in voor deze leuke upcycling boodschappentas gemaakt van denim.", storeItemImage: "denim-bag", storeItemPrice: 5)
    var storeItem1 = StoreItem(storeItemName: "10% korting bij de aanschaf van een Go-Upcycle", storeItemDescription: "Krijg 10% korting bij de aanschaf van een Go-Upcycle.", storeItemImage: "fiets2", storeItemPrice: 1)
    var storeItem3 = StoreItem(storeItemName: "10% korting op vintage kleding of schoenen", storeItemDescription: "Krijg 10% korting bij de aanschaf van vintage kleding of schoenen in de RecyQ Store.", storeItemImage: "clothingStore", storeItemPrice: 1)
    var storeItem2 = StoreItem(storeItemName: "Doneer aan het Buurtafvalfonds", storeItemDescription: "Doneer RecyQ token aan het Buurtafvalfonds voor ondersteuning van buurtactiviteiten.", storeItemImage: "buurtactiviteitStore", storeItemPrice: 1)

    @IBOutlet weak var numberOfTokensLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        storeItemArray = [storeItem1, storeItem2, storeItem3, storeItem4]
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let nib = UINib.init(nibName: "StoreTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(animated: Bool) {
            
            do {
                reachability = try Reachability.reachabilityForInternetConnection()
            } catch {
                print("Unable to create Reachability")
                return
            }
            
            reachability!.whenReachable = { reachability in
                // this is called on a background thread, but UI updates must
                // be on the main thread, like this:
                dispatch_async(dispatch_get_main_queue()) {
                    if reachability.isReachableViaWiFi() {
                        print("Reachable via WiFi")
                    } else {
                        print("Reachable via Cellular")
                    }
                }
            }
            
            reachability!.whenUnreachable = { reachability in
                // this is called on a background thread, but UI updates must
                // be on the main thread, like this:
                dispatch_async(dispatch_get_main_queue()) {
                    print("Not reachable")
                    
                    let alert = UIAlertController(title: "Oeps!", message: "Please connect to the internet to use the RecyQ app.", preferredStyle: .Alert)
                    let okayAction = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction) -> Void in
                    }
                    alert.addAction(okayAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
            
            do {
                try reachability!.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            
        

        
        ref.observeAuthEventWithBlock { authData in
            if self.ref.authData != nil {
                
                self.ref.queryOrderedByChild("uid").queryEqualToValue(self.ref.authData.uid).observeEventType(.ChildAdded, withBlock: { snapshot in
                    
                   let newSpentCoinsAmount = snapshot.value.objectForKey("spentCoins") as? Int
            
                let totalWasteAmount =  user!.amountOfPlastic! + user!.amountOfPaper! + user!.amountOfTextile! + user!.amountOfIron! + user!.amountOfEWaste! + user!.amountOfBioWaste!
                
                let tokenAmount = round(totalWasteAmount/35)
                
                numberOfTokens = (Int(tokenAmount))  - (newSpentCoinsAmount)!
                
                // this weird piece of code is here as a failsafe because sometimes I think the numberOfTokens amount isn't updated in time enough from data on the backend to prevent a negative token balance. TODO: Find another fix for this.
                    
                    if numberOfTokens <= 0 {
                        self.numberOfTokensLabel.text = "0"
                    } else {
                        self.numberOfTokensLabel.text = "\(numberOfTokens)"
                    }
                
//                self.numberOfTokensLabel.text = "\(numberOfTokens)"
        
        
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeItemArray.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 307
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StoreTableViewCell
        
        let storeItem = storeItemArray[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        cell.title.text = storeItem.storeItemName
        //cell.descriptionLabel.text = storeItem.storeItemDescription
        cell.storeItemImageView.image = storeItem.storeItemImage
        cell.tokenImageView.image = UIImage (named: "recyqToken")
        
        if let price = storeItem.storeItemPrice {
                cell.storeItemPrice.text = "\(price)"
        }
   
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storeDetailVC = StoreDetailViewController()
        let storeItem = storeItemArray[indexPath.row]
        storeDetailVC.storeItem = storeItem
        let navigationController = UINavigationController(rootViewController: storeDetailVC)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
        self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }

}
