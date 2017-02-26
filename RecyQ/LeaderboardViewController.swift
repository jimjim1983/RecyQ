//
//  LeaderboardViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 4/29/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var wasteDictionary = [String: Double]()
    
    var snapshotArray = [FIRDataSnapshot]()
    
    @IBOutlet weak var tableView: UITableView!

    
    // Test users for the leaderboards
    var userArray = [User]()
    var testUser1 = User(name: "Jim", addedByUser: "Recyq", completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: "0", spentCoins: 0)
    var testUser2 = User(name: "Alyson", addedByUser: "Recyq", completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: "0", spentCoins: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
                
        userArray = [testUser1,testUser2]
        userArray.sort(by: {$1.amountOfPlastic < $0.amountOfPlastic})
        
                tableView.dataSource = self
                tableView.delegate = self
                tableView.allowsSelection = false
                tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
                let nib = UINib.init(nibName: "CommunityTableViewCell", bundle: nil)
                self.tableView.register(nib, forCellReuseIdentifier: "cell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
        
        getAmountOfWaste()
    }
    
    func getAmountOfWaste() {
        
       FirebaseHelper.References.clientsRef.queryOrdered(byChild: "amountOfBioWaste").observe(.value, with: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                self.snapshotArray = snapshots
                
                for item in self.snapshotArray {
                    
                    let amountOfPlastic = (item.value as AnyObject).object(forKey: "amountOfPlastic") as! Double
                    let amountOfBioWaste = (item.value as AnyObject).object(forKey: "amountOfBioWaste") as! Double
                    let amountOfEWaste = (item.value as AnyObject).object(forKey: "amountOfEWaste") as! Double
                    let amountOfIron = (item.value as AnyObject).object(forKey: "amountOfIron") as! Double
                    let amountOfPaper = (item.value as AnyObject).object(forKey: "amountOfPaper") as! Double
                    let amountOfTextile = (item.value as AnyObject).object(forKey: "amountOfTextile") as! Double
                    
                    let wasteAmount = (amountOfPlastic + amountOfBioWaste + amountOfEWaste + amountOfIron + amountOfPaper + amountOfTextile)
                    
                    if let username = (item.value as AnyObject).object(forKey: "name") as? String {
                    
                        self.wasteDictionary["\(username)"] = wasteAmount
                    }
                }
                self.tableView.reloadData()
            }
            
            print(self.wasteDictionary)
            
        })
    }
    

    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.wasteDictionary.count
        }
    
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommunityTableViewCell
            
            let sortedArrayOfWasteDictionaries = (Array(wasteDictionary).sorted {$1.1 < $0.1})
            
//            for (k, v) in sortedArrayOfWasteDictionaries {
//                cell.nameLabel.text = k
//                cell.co2SavedLabel.text = "\(v)"
//            }
            
            let leaderboardArray = sortedArrayOfWasteDictionaries[indexPath.row]
            
            cell.nameLabel.text = leaderboardArray.0
            cell.co2SavedLabel.text = "\(leaderboardArray.1) kg"
    
//            let user = userArray[indexPath.row]
//            cell.nameLabel.text = user.name
    
            //change amountOfPlastic to co2 saved calculation
//            if let co2Saved = user.amountOfPlastic {
//                cell.co2SavedLabel.text = "\(co2Saved)"
//            }
            return cell
        }
    
    @IBAction func terugButtonPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    



}
