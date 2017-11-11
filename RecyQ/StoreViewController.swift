//
//  StoreViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase

class StoreViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var shops = [Shop]()
    var numberOfTokens = 0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Recyq Shop"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        loadShopsFromFirebase()
        
        let nib = UINib.init(nibName: "StoreTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
            
        FIRAuth.auth()!.addStateDidChangeListener { (auth, user) in
            if let user = user {
                FirebaseHelper.queryOrderedBy(child: "uid", value: user.uid, completionHandler: { (user) in
                    let newSpentCoinsAmount = user.spentCoins ?? 0
                    let totalWasteAmount =  user.amountOfPlastic + user.amountOfPaper + user.amountOfTextile + user.amountOfEWaste + user.amountOfBioWaste + (user.amountOfGlass ?? 0)
                    let tokenAmount = (totalWasteAmount / 35).rounded(.down)
                    self.numberOfTokens = (Int(tokenAmount))  - (newSpentCoinsAmount)
                })
            }
        }
    }
    
    fileprivate func loadShopsFromFirebase() {
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
                        self.activityIndicator.stopAnimating()
                    })
                }
            }
        })
    }
}

extension StoreViewController: UITableViewDataSource {
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
        cell.storeName.text = " " + shop.shopName
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.numberOfTokens <= 0 {
            return "Je hebt geen tokens beschikbaar."
        } else {
            return self.numberOfTokens == 1 ? "Je hebt \(self.numberOfTokens) token." : "Je hebt \(self.numberOfTokens) tokens."
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
        header.textLabel?.font = UIFont(name: "PT Mono", size: 15)
        header.textLabel?.textAlignment = .center
    }
}

extension StoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storeDetailVC = StoreDetailViewController()
        let shop = self.shops[indexPath.row]
        storeDetailVC.shop = shop
        storeDetailVC.numberOfTokens = self.numberOfTokens
        self.navigationController?.pushViewController(storeDetailVC, animated: true)
    }
}
