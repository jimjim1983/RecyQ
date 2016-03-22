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
    @IBOutlet var GFTLabel: UILabel!
    @IBOutlet var depositsLabel: UILabel!

    

    
    var testUser = User(username: "HenkDeVries77", userID: "1234567", password: "wachtwoord", amountOfPlastic: 10.1, amountOfPaper: 1.3, amountOfTextile: 5.7, amountOfGFT: 50, amountOfDeposits: 0.8)

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
        if let GFT = testUser.amountOfGFT {
            GFTLabel.text = "\(GFT) KG GFT Afval"
        }
        if let deposits = testUser.amountOfDeposits {
            depositsLabel.text = "€\(deposits) statiegeld"
        }

    }

}
