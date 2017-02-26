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
    
    
    let ref = FIRDatabase.database().reference()
    
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
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        let nib = UINib.init(nibName: "StoreTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
            
        

        
//        ref.observeAuthEvent { authData in
//            if self.ref?.authData != nil {
//                
//                self.ref?.queryOrdered(byChild: "uid").queryEqual(toValue: self.ref?.authData.uid).observe(.childAdded, with: { snapshot in
//                    
//                   let newSpentCoinsAmount = (snapshot?.value as AnyObject).object(forKey: "spentCoins") as? Int
//            
//                let totalWasteAmount =  user!.amountOfPlastic! + user!.amountOfPaper! + user!.amountOfTextile! + user!.amountOfIron! + user!.amountOfEWaste! + user!.amountOfBioWaste!
//                
//                let tokenAmount = round(totalWasteAmount/35)
//                
//                numberOfTokens = (Int(tokenAmount))  - (newSpentCoinsAmount)!
//                
//                // this weird piece of code is here as a failsafe because sometimes I think the numberOfTokens amount isn't updated in time enough from data on the backend to prevent a negative token balance. TODO: Find another fix for this.
//                    
//                    if numberOfTokens <= 0 {
//                        self.numberOfTokensLabel.text = "0"
//                    } else {
//                        self.numberOfTokensLabel.text = "\(numberOfTokens)"
//                    }
//                
////                self.numberOfTokensLabel.text = "\(numberOfTokens)"
//        
//        
//                })
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeItemArray.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 307
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoreTableViewCell
        
        let storeItem = storeItemArray[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        cell.title.text = storeItem.storeItemName
        //cell.descriptionLabel.text = storeItem.storeItemDescription
        cell.storeItemImageView.image = storeItem.storeItemImage
        cell.tokenImageView.image = UIImage (named: "recyqToken")
        
        if let price = storeItem.storeItemPrice {
                cell.storeItemPrice.text = "\(price)"
        }
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storeDetailVC = StoreDetailViewController()
        let storeItem = storeItemArray[indexPath.row]
        storeDetailVC.storeItem = storeItem
        let navigationController = UINavigationController(rootViewController: storeDetailVC)
        
        DispatchQueue.main.async { () -> Void in
        self.present(navigationController, animated: true, completion: nil)
        }
    }

}
