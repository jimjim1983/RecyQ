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
    
    var storeItem1 = StoreItem(storeItemName: "Upcycling boodschappentas gemaakt van denim", storeItemDescription: "5 CO2 tokens geven recht op een gratis upcycling boodschappentas gemaakt van denim.", storeItemImage: "upcyclingBagStore", storeItemPrice: 1)
    var storeItem2 = StoreItem(storeItemName: "10% korting bij de aanschaf van een Go-Upcycle", storeItemDescription: "1 CO2 token geeft eenmalig recht op 10% korting bij de aanschaf van een Go-Upcycle.", storeItemImage: "bicycleStore", storeItemPrice: 1)
    var storeItem3 = StoreItem(storeItemName: "10% korting bij de aanschaf van vintage kleding/schoenen in de RecyQ Store", storeItemDescription: "1 CO2 token geeft recht op 10% korting bij de aanschaf van vintage kleding/schoenen in de RecyQ Store.", storeItemImage: "clothingStore", storeItemPrice: 1)
    var storeItem4 = StoreItem(storeItemName: "Doneer aan het Buurtafvalfonds", storeItemDescription: "Doneer CO2 token aan het Buurtafvalfonds voor ondersteuning van buurtactiviteiten.", storeItemImage: "buurtactiviteitStore", storeItemPrice: 1)

    
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
        return self.view.frame.size.height/2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StoreTableViewCell
        
        let storeItem = storeItemArray[indexPath.row]
        
        cell.title.text = storeItem.storeItemName
        cell.descriptionLabel.text = storeItem.storeItemDescription
        cell.storeItemImageView.image = storeItem.storeItemImage
        
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
