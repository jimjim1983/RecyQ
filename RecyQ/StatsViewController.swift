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
//    @IBOutlet var userIDLabel: UILabel!
    @IBOutlet var plasticLabel: UILabel!
    @IBOutlet var paperLabel: UILabel!
    @IBOutlet var textileLabel: UILabel!
    @IBOutlet var ironLabel: UILabel!
    @IBOutlet var eWasteLabel: UILabel!
    @IBOutlet var bioWasteLabel: UILabel!
    @IBOutlet var navigationBar: UINavigationBar!

    //Navbar
    @IBOutlet var navigationBarTitle: UINavigationItem!
    @IBOutlet var navigationBarImage: UIImageView!
    @IBOutlet var tokenAmountLabel: UILabel!

    @IBOutlet var scrollView: UIScrollView!
    

    
    var testUser = User(username: "Jimsalabim", userID: "A0123131", password: "hallo", amountOfPlastic: 0.4, amountOfPaper: 0.9, amountOfTextile: 1.4, amountOfIron: 32.1, amountOfEWaste: 0.2, amountOfBioWaste: 12.3, amountOfTokens: 4)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.tintColor = UIColor.greenColor()
        navigationBarTitle.title = testUser.username
        navigationBarImage.image = UIImage(named: "token")
        
        if let tokenAmount = testUser.amountOfTokens {
        tokenAmountLabel.text = "\(tokenAmount)"
        }
        
//        userIDLabel.text = testUser.userID
        if let plastic = testUser.amountOfPlastic {
            plasticLabel.text = "\(plastic)"
        }
        if let paper = testUser.amountOfPaper {
            paperLabel.text = "\(paper)"
        }
        if let textile = testUser.amountOfTextile {
            textileLabel.text = "\(textile)"
        }
        if let iron = testUser.amountOfIron {
            ironLabel.text = "\(iron)"
        }
        if let eWaste = testUser.amountOfEWaste {
            eWasteLabel.text = "\(eWaste)"
        }
        if let bioWaste = testUser.amountOfBioWaste {
            bioWasteLabel.text = "\(bioWaste)"
        }
        
        


    }

}
