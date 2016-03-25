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
    var amountOfIron: Double?
    var amountOfEWaste: Double?
    var amountOfBioWaste: Double?
    var amountOfTokens: Int?
    
    init(username: String, userID: String, password: String, amountOfPlastic: Double, amountOfPaper: Double, amountOfTextile: Double, amountOfIron: Double, amountOfEWaste: Double, amountOfBioWaste: Double, amountOfTokens: Int) {
        self.username = username
        self.userID = userID
        self.password = password
        self.amountOfPlastic = amountOfPlastic
        self.amountOfPaper = amountOfPaper
        self.amountOfTextile = amountOfTextile
        self.amountOfIron = amountOfIron
        self.amountOfEWaste = amountOfEWaste
        self.amountOfBioWaste = amountOfBioWaste
        self.amountOfTokens = amountOfTokens
    }
    
}