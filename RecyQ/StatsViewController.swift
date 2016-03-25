//
//  StatsViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var userIDLabel: UILabel!
    @IBOutlet var plasticLabel: UILabel!
    @IBOutlet var paperLabel: UILabel!
    @IBOutlet var textileLabel: UILabel!
    @IBOutlet var ironLabel: UILabel!
    @IBOutlet var eWasteLabel: UILabel!
    @IBOutlet var bioWasteLabel: UILabel!



    

    
    var testUser = User(username: "Jimsalabim", userID: "A0123131", password: "hallo", amountOfPlastic: 0.4, amountOfPaper: 0.9, amountOfTextile: 1.4, amountOfIron: 32.1, amountOfEWaste: 0.2, amountOfBioWaste: 12.3)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = testUser.username
        userIDLabel.text = testUser.userID
        if let plastic = testUser.amountOfPlastic {
            plasticLabel.text = "\(plastic) KG plastic"
        }
        if let paper = testUser.amountOfPaper {
            paperLabel.text = "\(paper) KG papier"
        }
        if let textile = testUser.amountOfTextile {
            textileLabel.text = "\(textile) KG textiel"
        }
        if let iron = testUser.amountOfIron {
            ironLabel.text = "\(iron) KG IJzer"
        }
        if let eWaste = testUser.amountOfEWaste {
            eWasteLabel.text = "\(eWaste) KG E-Waste"
        }
        if let bioWaste = testUser.amountOfBioWaste {
            bioWasteLabel.text = "\(bioWaste) KG of Bio Waste"
        }


    }

}
