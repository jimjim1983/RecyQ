//
//  StoreViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit



class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var storeItemArray = [StoreItem]()
    
    var storeItem1 = StoreItem(storeItemName: "Free Buurthuis Breakfast", storeItemDescription: "Redeem one token for a free breakfast at Buurthuis.", storeItemLogo: "stats", storeItemImage: "stats", storeItemPrice: 1)
    var storeItem2 = StoreItem(storeItemName: "50% korting op een tweedehands fiets", storeItemDescription: "Redeem three tokens for a 50% discount off any bicycle at the Kroy Social Enterprise Pop-Up Store", storeItemLogo: "stats", storeItemImage: "stats", storeItemPrice: 3)
    var storeItem3 = StoreItem(storeItemName: "50% korting op tweedehandse kleding", storeItemDescription: "Redeem two tokens for a 50% discount off any clothing purchase at the Kroy Social Enterprise Pop-Up Store", storeItemLogo: "stats", storeItemImage: "stats", storeItemPrice: 2)
    var storeItem4 = StoreItem(storeItemName: "50% korting op kleermaker reparaties", storeItemDescription: "Redeem two tokens for a 50% discount off tailor repairs at the Kroy Social Enterprise Pop-Up Store", storeItemLogo: "stats", storeItemImage: "stats", storeItemPrice: 2)

    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        storeItemArray = [storeItem1, storeItem2, storeItem3, storeItem4]
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.allowsSelection = true
        
        let nib = UINib.init(nibName: "StoreTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeItemArray.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.height/3.5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StoreTableViewCell
        
        let storeItem = storeItemArray[indexPath.row]
        
        cell.title.text = storeItem.storeItemName
        cell.descriptionLabel.text = storeItem.storeItemDescription
        cell.storeItemImageView.image = storeItem.storeItemImage
        cell.storeItemLogo.image = storeItem.storeItemLogo
        
        if let price = storeItem.storeItemPrice {
            if price <= 1 {
                cell.storeItemPrice.text = "\(price) token"
            } else {
         cell.storeItemPrice.text = "\(price) tokens"
            }
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
