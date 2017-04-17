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
    var storeItem3 = StoreItem(storeItemName: "10% korting op vintage kleding of schoenen", storeItemDescription: "Krijg 10% korting bij de aanschaf van vintage kleding of schoenen in de RecyQ Store.", storeItemImage: "storepic", storeItemPrice: 1)
    var storeItem2 = StoreItem(storeItemName: "Doneer aan het Buurtafvalfonds", storeItemDescription: "Doneer RecyQ token aan het Buurtafvalfonds voor ondersteuning van buurtactiviteiten.", storeItemImage: "buurtactiviteitStore", storeItemPrice: 1)

    @IBOutlet weak var numberOfTokensLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Recyq Shop"
        
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
            
        FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
            if let user = user {
                FirebaseHelper.queryOrderedBy(child: "uid", value: user.uid, completionHandler: { (user) in
                    let newSpentCoinsAmount = user.spentCoins ?? 0
                    let totalWasteAmount =  user.amountOfPlastic + user.amountOfPaper + user.amountOfTextile + user.amountOfEWaste + user.amountOfBioWaste
                    let tokenAmount = round(totalWasteAmount/35)
                    numberOfTokens = (Int(tokenAmount))  - (newSpentCoinsAmount)
                    if numberOfTokens <= 0 {
                        self.numberOfTokensLabel.text = "Je hebt nog geen tokens verdiend."
                    } else {
                        self.numberOfTokensLabel.text = "Je hebt \(numberOfTokens) tokens verdiend."
                    }
                })
            }
        }
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
        cell.storeItemImageView.image = storeItem.storeItemImage
        
        if let price = storeItem.storeItemPrice {
            if price > 1 {
                cell.tokenLabel.text = "\(price) TOKENS"
            }
            else{
                cell.tokenLabel.text = "\(price) TOKEN"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storeDetailVC = StoreDetailViewController()
        let storeItem = storeItemArray[indexPath.row]
        storeDetailVC.storeItem = storeItem
        self.navigationController?.pushViewController(storeDetailVC, animated: true)
    }

}
