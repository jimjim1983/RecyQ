//
//  CommunityViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 3/29/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class CommunityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var communityCounterView: UIView!
    @IBOutlet var communityCounterLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    
    // Test users for the leaderboards
    var userArray = [User]()
    var testUser1 = User(username: "Gerda Hout", userID: "A0123543", password: "hallo", amountOfPlastic: 12.4, amountOfPaper: 0.9, amountOfTextile: 1.4, amountOfIron: 2.5, amountOfEWaste: 7.2, amountOfBioWaste: 0.3, amountOfTokens: 54)
    var testUser2 = User(username: "Truus Mol", userID: "A0123457", password: "hallo", amountOfPlastic: 9.6, amountOfPaper: 5.5, amountOfTextile: 8.4, amountOfIron: 65.1, amountOfEWaste: 1.8, amountOfBioWaste: 1.3, amountOfTokens: 2)
    var testUser3 = User(username: "Willem Boer", userID: "A0123124", password: "hallo", amountOfPlastic: 87.4, amountOfPaper: 5.9, amountOfTextile: 33.2, amountOfIron: 4.2, amountOfEWaste: 9.1, amountOfBioWaste: 31.6, amountOfTokens: 43)
    var testUser4 = User(username: "Frank Plastiek", userID: "A0123253", password: "hallo", amountOfPlastic: 6.5, amountOfPaper: 7.9, amountOfTextile: 7.4, amountOfIron: 2.1, amountOfEWaste: 9.2, amountOfBioWaste: 120.3, amountOfTokens: 11)
    var testUser5 = User(username: "Willy Arnolds", userID: "A0123323", password: "hallo", amountOfPlastic: 14.4, amountOfPaper: 45.9, amountOfTextile: 3.1, amountOfIron: 52.1, amountOfEWaste: 1.9, amountOfBioWaste: 128.3, amountOfTokens: 23)
    var testUser6 = User(username: "Piet Plof", userID: "A012354", password: "hallo", amountOfPlastic: 5.4, amountOfPaper: 7.9, amountOfTextile: 3.6, amountOfIron: 6.6, amountOfEWaste: 8.2, amountOfBioWaste: 10.4, amountOfTokens: 54)
    var testUser7 = User(username: "Wanda Wout", userID: "A0123121", password: "hallo", amountOfPlastic: 6.1, amountOfPaper: 3.2, amountOfTextile: 11.1, amountOfIron: 123.1, amountOfEWaste: 5.2, amountOfBioWaste: 12.1, amountOfTokens: 87)
    var testUser8 = User(username: "Linda Lop", userID: "A0123112", password: "hallo", amountOfPlastic: 4.5, amountOfPaper: 7.5, amountOfTextile: 4.2, amountOfIron: 11.1, amountOfEWaste: 26.3, amountOfBioWaste: 12.7, amountOfTokens: 25)
    var testUser9 = User(username: "Peter Pol", userID: "A0123131", password: "hallo", amountOfPlastic: 6.7, amountOfPaper: 25.2, amountOfTextile: 65.1, amountOfIron: 45.1, amountOfEWaste: 18.1, amountOfBioWaste: 212.1, amountOfTokens: 85)
    var testUser10 = User(username: "Wim Pool", userID: "A0123131", password: "hallo", amountOfPlastic: 12.4, amountOfPaper: 12.9, amountOfTextile: 12.4, amountOfIron: 12.1, amountOfEWaste: 12.2, amountOfBioWaste: 30.3, amountOfTokens: 19)
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userArray = [testUser1,testUser2,testUser3,testUser4,testUser5,testUser6,testUser7,testUser8,testUser9,testUser10]
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor(red: 33/255, green: 210/255, blue: 37/255, alpha: 1.0)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        imageView.image = UIImage(named: "buurtactiviteitStore")
        
        let nib = UINib.init(nibName: "CommunityTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        if let communityMoney = testUser1.amountOfBioWaste {
            communityCounterLabel.text = "\(communityMoney)"
        }
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
        cell.nameLabel.text = user.username
        
        if let co2Saved = user.amountOfPlastic {
            cell.co2SavedLabel.text = "\(co2Saved)"
        }
        return cell
    }

    
    
    
    
}
