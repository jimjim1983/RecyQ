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
    
    var shops = [Shop]()
    
    var storeItem4 = StoreItem(storeItemName: "Upcycling boodschappentas gemaakt van denim", storeItemDescription: "Wissel je tokens in voor deze leuke upcycling boodschappentas gemaakt van denim.", storeItemImage: "denim-bag", storeItemPrice: 5)
    var storeItem1 = StoreItem(storeItemName: "10% korting bij de aanschaf van een Go-Upcycle", storeItemDescription: "Krijg 10% korting bij de aanschaf van een Go-Upcycle.", storeItemImage: "fiets2", storeItemPrice: 1)
    var storeItem3 = StoreItem(storeItemName: "10% korting op vintage kleding of schoenen", storeItemDescription: "Krijg 10% korting bij de aanschaf van vintage kleding of schoenen in de RecyQ Store.", storeItemImage: "storepic", storeItemPrice: 1)
    var storeItem2 = StoreItem(storeItemName: "Doneer aan het Buurtafvalfonds", storeItemDescription: "Doneer RecyQ token aan het Buurtafvalfonds voor ondersteuning van buurtactiviteiten.", storeItemImage: "buurtactiviteitStore", storeItemPrice: 1)

    @IBOutlet weak var numberOfTokensLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate func getShopsFromFirebase() {
        FirebaseHelper.References.shops.observe(.value, with: { (snapshot) in
            if let result = snapshot.children.allObjects as? [FIRDataSnapshot] {
                var shops: [Shop] = []
                for shopName in result {
                    let shopNameKey = shopName.key
                    FirebaseHelper.References.shops.child(shopNameKey).observe(.value, with: { (snapshot) in
                        for item in snapshot.children {
                            let recyqShop = Shop(snapShot: item as! FIRDataSnapshot)
                            shops.append(recyqShop)
                        }
                        self.shops = shops
                        self.tableView.reloadData()
                    })
                }
            }
        })
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        getShopsFromFirebase()
        /*self.navigationItem.title = "Recyq Shop"
        let name = "Buurtafvalfonds"
        let image = #imageLiteral(resourceName: "buurtactiviteitStore")
        let data = UIImageJPEGRepresentation(image, 0.5)
        let imageString = data?.base64EncodedString(options: .lineLength64Characters)
        let shopItem = Shop(shopName: name, itemName: "Doneer aan het Buurtafvalfonds", detailDescription: "Doneer je RecyQ token aan het Buurtafvalfonds voor ondersteuning van buurtactiviteiten.", tokenAmount: 1, imageString: imageString!)
        let shop = FirebaseHelper.References.shops.child(name).childByAutoId()
        //shop.removeValue()
        
        
        shop.setValue(shopItem.toAnyObject())
        */
        
        //storeItemArray = [storeItem1, storeItem2, storeItem3, storeItem4]
        
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
                        if let numberOfTokens = numberOfTokens {
                            self.numberOfTokensLabel.text = "Je hebt \(numberOfTokens) tokens verdiend."
                        }
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shops.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 307
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoreTableViewCell
        
        let shop = self.shops[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        cell.title.text = shop.itemName
        let imageString = shop.imageString
        if let imageData = Data(base64Encoded: imageString, options: .ignoreUnknownCharacters) {
            DispatchQueue.main.async {
                cell.storeItemImageView.image = UIImage(data: imageData)
            }
        }
        
        let price = shop.tokenAmount
        if price > 1 {
            cell.tokenLabel.text = "\(price) TOKENS"
        }
        else {
            cell.tokenLabel.text = "\(price) TOKEN"
        }
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storeDetailVC = StoreDetailViewController()
        let shop = self.shops[indexPath.row]
        storeDetailVC.shop = shop
        self.navigationController?.pushViewController(storeDetailVC, animated: true)
    }

}
