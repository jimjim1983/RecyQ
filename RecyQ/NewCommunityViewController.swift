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
    @IBOutlet fileprivate var treeIconImageView: UIImageView!
    @IBOutlet fileprivate var totalTreesSaved: UILabel!
    @IBOutlet fileprivate var totalTokensSaved: UILabel!

    
    fileprivate var wasteArray = [Double]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getTotalCo2AndRecycledAmounts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let treeIcon = #imageLiteral(resourceName: "Boom Icon")
        treeIcon.withRenderingMode(.automatic)
        self.treeIconImageView.image = treeIcon
        self.treeIconImageView.tintColor = .white
    }
    
    fileprivate func setupViews() {
        self.navigationItem.title = "Community"
        self.watGaanWeDoenButton.addBorderWith(width: 1, color: .darkGray)
        self.wieStaatErBovenaanButton.addBorderWith(width: 1, color: .darkGray)
        self.communityPartnersButton.addBorderWith(width: 1, color: .darkGray)
        // Sets the alpha value for the four value labels.
        set(alpha: 0)
    }
    
    // This code needs refactoring. For now i copied it from the CommunityVC.
    fileprivate func getTotalCo2AndRecycledAmounts() {
        
        FirebaseHelper.References.clientsRef.queryOrdered(byChild: "amountOfBioWaste").observe(.value, with: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for item in snapshots {
                    let amountOfPlastic = (item.value as AnyObject).object(forKey: "amountOfPlastic") as? Double
                    let amountOfBioWaste = (item.value as AnyObject).object(forKey: "amountOfBioWaste") as? Double
                    let amountOfEWaste = (item.value as AnyObject).object(forKey: "amountOfEWaste") as? Double
                    let amountOfPaper = (item.value as AnyObject).object(forKey: "amountOfPaper") as? Double
                    let amountOfTextile = (item.value as AnyObject).object(forKey: "amountOfTextile") as? Double
                    self.wasteArray.append(amountOfPlastic!)
                    self.wasteArray.append(amountOfBioWaste!)
                    self.wasteArray.append(amountOfEWaste!)
                    self.wasteArray.append(amountOfPaper!)
                    self.wasteArray.append(amountOfTextile!)
                }
                
            }
            
            let total = self.wasteArray.reduce(0.0, +)
            self.recycledTotalLabel.text = "\(total.rounded(.down))"
            
            let co2Amount = (round((total/35) * 50))
            self.co2TotalLabel.text = "\(co2Amount)"
            
            let totalTokens = total / 35
            self.totalTokensSaved.text = totalTokens.stringFromDoubleWth(fractionDigits: 0) + " TOKENS"
            
            let treesSaved = total / 11.6
            self.totalTreesSaved.text = treesSaved.stringFromDoubleWth(fractionDigits: 0)
            // Animates the calculated values in sight from alpha 0 to 1.
            self.animateValuesIn()
        })
    }

    @IBAction func watGaanWeDoenButtonTapped(_ sender: Any) {
        let infoVC = NewInfoViewController()
        let sender = sender as! UIButton
        infoVC.title = sender.title(for: .normal)
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    @IBAction func wieStaatErBovenaanButtonTapped(_ sender: Any) {
        let leaderboardVC = LeaderboardViewController()
        self.navigationController?.pushViewController(leaderboardVC, animated: true)
    }
    
    @IBAction func communityPartnersButtonTapped(_ sender: Any) {
        let partnersVC = PartnersViewController()
        self.navigationController?.pushViewController(partnersVC, animated: true)
    }
}

extension NewCommunityViewController {
    func set(alpha: CGFloat) {
        self.recycledTotalLabel.alpha = alpha
        self.co2TotalLabel.alpha = alpha
        self.totalTokensSaved.alpha = alpha
        self.totalTreesSaved.alpha = alpha
    }
    
    func animateValuesIn() {
        UIView.animate(withDuration: 0.5) { 
            self.set(alpha: 1)
        }
    }
}
