//
//  StoreViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit



class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var charityArray = [Charity]()
    
    var charity1 = Charity(charityName: "Bamboo bikes in Ghana", charityDescription: "Leuke fietsen", charityLogo: "stats", charityImage: "stats")
    var charity2 = Charity(charityName: "Korting afvalstoffenheffing", charityDescription: "Minder betalen!", charityLogo: "stats", charityImage: "stats")
    
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        charityArray = [charity1, charity2]
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.allowsSelection = true
        
        let nib = UINib.init(nibName: "StoreTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charityArray.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.size.height/3.5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StoreTableViewCell
        
        let charity = charityArray[indexPath.row]
        cell.textLabel!.text = charity.charityName
    
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storeDetailVC = StoreDetailViewController()
        let navigationController = UINavigationController(rootViewController: storeDetailVC)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    

}
