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
    
    var clientsRef = Firebase(url: "https://recyqdb.firebaseio.com/clients")
    
    var wasteDictionary = [String: Double]()
    
    var snapshotArray = [FDataSnapshot]()
    
    @IBOutlet weak var tableView: UITableView!

    
    // Test users for the leaderboards
    var userArray = [User]()
    var testUser1 = User(name: "Jim", addedByUser: "Recyq", completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: "0", spentCoins: 0)
    var testUser2 = User(name: "Alyson", addedByUser: "Recyq", completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: "0", spentCoins: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
//         getAmountOfWaste()
        
        userArray = [testUser1,testUser2]
        userArray.sortInPlace({$1.amountOfPlastic < $0.amountOfPlastic})
        
                tableView.dataSource = self
                tableView.delegate = self
                tableView.allowsSelection = false
//                tableView.backgroundColor = UIColor(red: 33/255, green: 210/255, blue: 37/255, alpha: 1.0)
                tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
                let nib = UINib.init(nibName: "CommunityTableViewCell", bundle: nil)
                self.tableView.registerNib(nib, forCellReuseIdentifier: "cell")

    }
    
    override func viewWillAppear(animated: Bool) {
       getAmountOfWaste()
        
            
            do {
                reachability = try Reachability.reachabilityForInternetConnection()
            } catch {
                print("Unable to create Reachability")
                return
            }
            
            reachability!.whenReachable = { reachability in
                // this is called on a background thread, but UI updates must
                // be on the main thread, like this:
                dispatch_async(dispatch_get_main_queue()) {
                    if reachability.isReachableViaWiFi() {
                        print("Reachable via WiFi")
                    } else {
                        print("Reachable via Cellular")
                    }
                }
            }
            
            reachability!.whenUnreachable = { reachability in
                // this is called on a background thread, but UI updates must
                // be on the main thread, like this:
                dispatch_async(dispatch_get_main_queue()) {
                    print("Not reachable")
                    
                    let alert = UIAlertController(title: "Oeps!", message: "Please connect to the internet to use the RecyQ app.", preferredStyle: .Alert)
                    let okayAction = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction) -> Void in
                    }
                    alert.addAction(okayAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }
            
            do {
                try reachability!.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            
        

//
//        self.clientsRef.queryOrderedByChild("amountOfBioWaste").observeEventType(.Value, withBlock: { snapshot in
//            
//            
//            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
//                
//                self.snapshotArray = snapshots
//                
//                for item in self.snapshotArray {
//                    
//                    let amountOfPlastic = item.value.objectForKey("amountOfPlastic") as? Double
//                    let amountOfBioWaste = item.value.objectForKey("amountOfBioWaste") as? Double
//                    let amountOfEWaste = item.value.objectForKey("amountOfEWaste") as? Double
//                    let amountOfIron = item.value.objectForKey("amountOfIron") as? Double
//                    let amountOfPaper = item.value.objectForKey("amountOfPaper") as? Double
//                    let amountOfTextile = item.value.objectForKey("amountOfTextile") as? Double
//                    
//                    let wasteAmount = amountOfPlastic! + amountOfBioWaste! + amountOfEWaste! + amountOfIron! + amountOfPaper! + amountOfTextile!
//                    
//                    if let username = item.value.objectForKey("name") as? String {
//                        
//                        self.wasteDictionary["\(username)"] = wasteAmount
//                    }
//                }
//                
//                self.tableView.reloadData()
//                
//            }
//            
//            print(self.wasteDictionary)
//            
//        })

        
    }
    
    func getAmountOfWaste() {
        
        self.clientsRef.queryOrderedByChild("amountOfBioWaste").observeEventType(.Value, withBlock: { snapshot in
            
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                self.snapshotArray = snapshots
                
                for item in self.snapshotArray {
                    
                    let amountOfPlastic = item.value.objectForKey("amountOfPlastic") as? Double
                    let amountOfBioWaste = item.value.objectForKey("amountOfBioWaste") as? Double
                    let amountOfEWaste = item.value.objectForKey("amountOfEWaste") as? Double
                    let amountOfIron = item.value.objectForKey("amountOfIron") as? Double
                    let amountOfPaper = item.value.objectForKey("amountOfPaper") as? Double
                    let amountOfTextile = item.value.objectForKey("amountOfTextile") as? Double
                    
                    let wasteAmount = amountOfPlastic! + amountOfBioWaste! + amountOfEWaste! + amountOfIron! + amountOfPaper! + amountOfTextile!
                    
                    if let username = item.value.objectForKey("name") as? String {
                    
                        self.wasteDictionary["\(username)"] = wasteAmount
                    }
                }
                self.tableView.reloadData()
            }
            
            print(self.wasteDictionary)
            
        })
    }
    

    
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.wasteDictionary.count
        }
    
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 60
        }
    
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CommunityTableViewCell
            
            let sortedArrayOfWasteDictionaries = (Array(wasteDictionary).sort {$1.1 < $0.1})
            
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
    
    @IBAction func terugButtonPressed(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    



}
