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
    
    var storeItem1 = StoreItem(storeItemName: "Upcycling boodschappentas gemaakt van denim", storeItemDescription: "5 RecyQ tokens geven recht op een gratis upcycling boodschappentas gemaakt van denim.", storeItemImage: "upcyclingBagStore", storeItemPrice: 5)
    var storeItem2 = StoreItem(storeItemName: "10% korting bij de aanschaf van een Go-Upcycle", storeItemDescription: "1 RecyQ token geeft eenmalig recht op 10% korting bij de aanschaf van een Go-Upcycle.", storeItemImage: "bicycleStore", storeItemPrice: 1)
    var storeItem3 = StoreItem(storeItemName: "10% korting bij de aanschaf van vintage kleding of schoenen in de RecyQ Store", storeItemDescription: "1 RecyQ token geeft recht op 10% korting bij de aanschaf van vintage kleding of schoenen in de RecyQ Store.", storeItemImage: "clothingStore", storeItemPrice: 1)
    var storeItem4 = StoreItem(storeItemName: "Doneer aan het Buurtafvalfonds", storeItemDescription: "Doneer RecyQ token aan het Buurtafvalfonds voor ondersteuning van buurtactiviteiten.", storeItemImage: "buurtactiviteitStore", storeItemPrice: 1)

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
        
        ref.observeAuthEventWithBlock { authData in
            if self.ref.authData != nil {
                
                self.ref.queryOrderedByChild("uid").queryEqualToValue(self.ref.authData.uid).observeEventType(.ChildAdded, withBlock: { snapshot in
                    
                   let newSpentCoinsAmount = snapshot.value.objectForKey("spentCoins") as? Int
            
                let totalWasteAmount =  user!.amountOfPlastic! + user!.amountOfPaper! + user!.amountOfTextile! + user!.amountOfIron! + user!.amountOfEWaste! + user!.amountOfBioWaste!
                
                let tokenAmount = round(totalWasteAmount/35)
                
                numberOfTokens = (Int(tokenAmount))  - (newSpentCoinsAmount)!
                
                self.numberOfTokensLabel.text = "\(numberOfTokens)"
        
        
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
        self.presentViewController(navigationController, animated: true, completion: nil)
    }

}
