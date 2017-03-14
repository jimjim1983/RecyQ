//
//  NewCommunityViewController.swift
//  RecyQ
//
//  Created by Supervisor on 14-03-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase

class NewCommunityViewController: UIViewController {
    
    @IBOutlet fileprivate var co2TotalLabel: UILabel!
    @IBOutlet fileprivate var recycledTotalLabel: UILabel!
    @IBOutlet fileprivate var watGaanWeDoenButton: UIButton!
    @IBOutlet fileprivate var wieStaatErBovenaanButton: UIButton!
    @IBOutlet fileprivate var communityPartnersButton: UIButton!
    
    fileprivate var wasteArray = [Double]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        getTotalCo2AndRecycledAmounts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func setupViews() {
        self.watGaanWeDoenButton.addBorderWith(width: 1, color: .darkGray)
        self.wieStaatErBovenaanButton.addBorderWith(width: 1, color: .darkGray)
        self.communityPartnersButton.addBorderWith(width: 1, color: .darkGray)
    }
    
    // This code needs refactoring. For now i copied it from the CommunityVC.
    fileprivate func getTotalCo2AndRecycledAmounts() {
        
        // go trough all coupons and find the one with the same user uid, then add them to the array for the tableview
        FirebaseHelper.References.clientsRef.queryOrdered(byChild: "amountOfBioWaste").observe(.value, with: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for item in snapshots {
                    let amountOfPlastic = (item.value as AnyObject).object(forKey: "amountOfPlastic") as? Double
                    let amountOfBioWaste = (item.value as AnyObject).object(forKey: "amountOfBioWaste") as? Double
                    let amountOfEWaste = (item.value as AnyObject).object(forKey: "amountOfEWaste") as? Double
                    let amountOfIron = (item.value as AnyObject).object(forKey: "amountOfIron") as? Double
                    let amountOfPaper = (item.value as AnyObject).object(forKey: "amountOfPaper") as? Double
                    let amountOfTextile = (item.value as AnyObject).object(forKey: "amountOfTextile") as? Double
                    self.wasteArray.append(amountOfPlastic!)
                    self.wasteArray.append(amountOfBioWaste!)
                    self.wasteArray.append(amountOfEWaste!)
                    self.wasteArray.append(amountOfIron!)
                    self.wasteArray.append(amountOfPaper!)
                    self.wasteArray.append(amountOfTextile!)
                }
                
            }
            
            var total = Double()
            
            for i in self.wasteArray {
                total = total + i
            }
            
            self.recycledTotalLabel.text = "\(round(total))"
            
            let co2Amount = (round((total/35) * 50))
            
            self.co2TotalLabel.text = "\(co2Amount)"
        })

    }

    @IBAction func watGaanWeDoenButtonTapped(_ sender: Any) {
        let infoVC = InfoViewController()
        self.present(infoVC, animated: true, completion: nil)
    }
    
    @IBAction func wieStaatErBovenaanButtonTapped(_ sender: Any) {
        let leaderboardVC = LeaderboardViewController()
        self.present(leaderboardVC, animated: true, completion: nil)
    }
    
    @IBAction func communityPartnersButtonTapped(_ sender: Any) {
        let partnersVC = PartnersViewController()
        self.present(partnersVC, animated: true, completion: nil)
    }
    
}
