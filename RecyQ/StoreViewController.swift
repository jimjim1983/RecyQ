//
//  StoreViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit



class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentStoreItem: StoreItem!

    var storeItemArray = [StoreItem]()
    
    var storeItem1 = StoreItem(storeItemName: "Bamboo bikes in Ghana", storeItemDescription: "Leuke fietsen", storeItemLogo: "stats", storeItemImage: "stats", storeItemPrice: 2)
    var storeItem2 = StoreItem(storeItemName: "Afvalstoffenheffing korting", storeItemDescription: "Minder betalen!", storeItemLogo: "stats", storeItemImage: "stats", storeItemPrice: 3)
    var storeItem3 = StoreItem(storeItemName: "Test item ZZ", storeItemDescription: "Is it working?", storeItemLogo: "stats", storeItemImage: "stats", storeItemPrice: 50)
    var storeItem4 = StoreItem(storeItemName: "Dancing puppies", storeItemDescription: "Dansende hondjes", storeItemLogo: "stats", storeItemImage: "stats", storeItemPrice: 500)

    
    
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
        
        currentStoreItem = storeItem
        cell.title.text = storeItem.storeItemName
        cell.descriptionLabel.text = storeItem.storeItemDescription
        cell.storeItemImageView.image = storeItem.storeItemImage
        cell.storeItemLogo.image = storeItem.storeItemLogo
        
        if let price = storeItem.storeItemPrice {
         cell.storeItemPrice.text = "\(price) tokens"
        }
   
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storeDetailVC = StoreDetailViewController()
        storeDetailVC.storeItem = currentStoreItem
        let navigationController = UINavigationController(rootViewController: storeDetailVC)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    

}
