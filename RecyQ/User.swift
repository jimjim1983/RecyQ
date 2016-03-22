//
//  User.swift
//  RecyQ
//
//  Created by Jim Petri on 22/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit


class User {
    
    var username : String?
    var userID : String?
    var password : String?
    var amountOfPlastic : Double?
    var amountOfPaper : Double?
    var amountOfTextile: Double?
    var amountOfGFT: Double?
    var amountOfDeposits: Double?
    
    init(username: String, userID: String, password: String, amountOfPlastic: Double, amountOfPaper: Double, amountOfTextile: Double, amountOfGFT: Double, amountOfDeposits: Double) {
        self.username = username
        self.userID = userID
        self.password = password
        self.amountOfPlastic = amountOfPlastic
        self.amountOfPaper = amountOfPaper
        self.amountOfTextile = amountOfTextile
        self.amountOfGFT = amountOfGFT
        self.amountOfDeposits = amountOfDeposits
    }
    
}