//
//  LeaderboardViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 4/29/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!

    
    // Test users for the leaderboards
    var userArray = [User]()
    var testUser1 = User(name: "Jim", addedByUser: "Recyq", completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: "0", spentCoins: 0)
    var testUser2 = User(name: "Alyson", addedByUser: "Recyq", completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: "0", spentCoins: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userArray = [testUser1,testUser2]
        userArray.sortInPlace({$1.amountOfPlastic < $0.amountOfPlastic})
        
                tableView.dataSource = self
                tableView.delegate = self
                tableView.allowsSelection = false
                tableView.backgroundColor = UIColor(red: 33/255, green: 210/255, blue: 37/255, alpha: 1.0)
                tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
                let nib = UINib.init(nibName: "CommunityTableViewCell", bundle: nil)
                self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")


        // Do any additional setup after loading the view.
    }
    
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return userArray.count
        }
    
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 22
        }
    
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CommunityTableViewCell
    
            let user = userArray[indexPath.row]
            cell.nameLabel.text = user.name
    
            //change amountOfPlastic to co2 saved calculation
            if let co2Saved = user.amountOfPlastic {
                cell.co2SavedLabel.text = "\(co2Saved)"
            }
            return cell
        }
    
    @IBAction func xButtonPressed(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }


}
