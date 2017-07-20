//
//  LeaderboardViewController.swift
//  RecyQ
//
//  Created by Alyson Vivattanapa on 4/29/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var wasteDictionary = [String: Double]()
    var snapshotArray = [FIRDataSnapshot]()
    var totalParticipantsItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
        getAmountOfWaste()
    }
    
    func setupViews() {
        title = "Ranglijst"
        let nib = UINib.init(nibName: "CommunityTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func getAmountOfWaste() {
       FirebaseHelper.References.clientsRef.queryOrdered(byChild: "amountOfBioWaste").observe(.value, with: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                self.snapshotArray = snapshots
                
                for item in self.snapshotArray {
                    
                    let amountOfPlastic = (item.value as AnyObject).object(forKey: "amountOfPlastic") as! Double
                    let amountOfBioWaste = (item.value as AnyObject).object(forKey: "amountOfBioWaste") as! Double
                    let amountOfEWaste = (item.value as AnyObject).object(forKey: "amountOfEWaste") as! Double
                    let amountOfPaper = (item.value as AnyObject).object(forKey: "amountOfPaper") as! Double
                    let amountOfTextile = (item.value as AnyObject).object(forKey: "amountOfTextile") as! Double
                    
                    let wasteAmount = (amountOfPlastic + amountOfBioWaste + amountOfEWaste + amountOfPaper + amountOfTextile)
                    
                    if let name = (item.value as AnyObject).object(forKey: "name") as? String {
                        if let lastName = (item.value as AnyObject).object(forKey: "lastName") as? String {
                            let fullName = name + " " + lastName
                            self.wasteDictionary["\(fullName)"] = wasteAmount
                        }
                    }
                }
                self.tableView.reloadData()
                self.showTotalParticipants()
            }
            print(self.wasteDictionary)
        })
    }
    
    func showTotalParticipants() {
        self.totalParticipantsItem = UIBarButtonItem(title: "\(self.snapshotArray.count)", style: .plain, target: nil, action: nil)
        self.totalParticipantsItem.tintColor = .lightGray
        self.navigationItem.setRightBarButton(self.totalParticipantsItem, animated: true)
    }
}

extension LeaderboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wasteDictionary.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommunityTableViewCell
        
        let sortedArrayOfWasteDictionaries = (Array(wasteDictionary).sorted {$1.1 < $0.1})
        let leaderboardArray = sortedArrayOfWasteDictionaries[indexPath.row]
        
        cell.nameLabel.text = leaderboardArray.0.capitalized
        cell.co2SavedLabel.text = "\(leaderboardArray.1) kg"
        
        return cell
    }
}
