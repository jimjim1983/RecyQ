//
//  User.swift
//  RecyQ
//
//  Created by Jim Petri on 22/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

//import UIKit
//
//
//class User {
//    
////    var username : String?
////    var userID : String?
////    var password : String?
////    var amountOfPlastic : Double?
////    var amountOfPaper : Double?
////    var amountOfTextile: Double?
////    var amountOfIron: Double?
////    var amountOfEWaste: Double?
////    var amountOfBioWaste: Double?
////    var amountOfTokens: Int?
////    var co2Saved: Double?
////    
////    init(username: String, userID: String, password: String, amountOfPlastic: Double, amountOfPaper: Double, amountOfTextile: Double, amountOfIron: Double, amountOfEWaste: Double, amountOfBioWaste: Double, amountOfTokens: Int) {
////        self.username = username
////        self.userID = userID
////        self.password = password
////        self.amountOfPlastic = amountOfPlastic
////        self.amountOfPaper = amountOfPaper
////        self.amountOfTextile = amountOfTextile
////        self.amountOfIron = amountOfIron
////        self.amountOfEWaste = amountOfEWaste
////        self.amountOfBioWaste = amountOfBioWaste
////        self.amountOfTokens = amountOfTokens
////        self.co2Saved = amountOfPaper*1.42857143 + amountOfPlastic*1.42857143 + amountOfEWaste*1.42857143 + amountOfBioWaste*1.42857143 + amountOfIron*1.42857143 + amountOfTextile*1.42857143
////    }
//
//    
//}

import Foundation
import Firebase

struct User {
    
    let key: String!
    let name: String!
    let addedByUser: String!
    let ref: Firebase?
    var completed: Bool!
    let amountOfPlastic: Double!
    var amountOfPaper: Double!
    let amountOfTextile: Double!
    let amountOfEWaste: Double!
    let amountOfBioWaste: Double!
    let amountOfIron: Double!
    let uid: String!
    
    // Initialize from arbitrary data
    init(name: String, addedByUser: String, completed: Bool, key: String = "",  amountOfPlastic: Double, amountOfPaper: Double, amountOfTextile: Double, amountOfEWaste: Double, amountOfBioWaste: Double, amountOfIron: Double, uid: String) {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.ref = nil
        self.amountOfPlastic = amountOfPlastic
        self.amountOfPaper = amountOfPaper
        self.amountOfTextile = amountOfTextile
        self.amountOfEWaste = amountOfEWaste
        self.amountOfBioWaste = amountOfBioWaste
        self.amountOfIron = amountOfIron
        self.uid = uid
    }
    
    init(snapshot: FDataSnapshot) {
        key = snapshot.key
        name = snapshot.value["name"] as? String
        addedByUser = snapshot.value["addedByUser"] as? String
        completed = snapshot.value["completed"] as? Bool
        ref = snapshot.ref
        amountOfPlastic = snapshot.value["amountOfPlastic"] as? Double
        amountOfPaper = snapshot.value["amountOfPaper"] as? Double
        amountOfTextile = snapshot.value["amountOfTextile"] as? Double
        amountOfEWaste = snapshot.value["amountOfEWaste"] as? Double
        amountOfBioWaste = snapshot.value["amountOfBioWaste"] as? Double
        amountOfIron = snapshot.value["amountOfIron"] as? Double
        uid = snapshot.value["uid"] as? String
    }
    
    func toAnyObject() -> AnyObject {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "completed": completed,
            "amountOfPlastic": amountOfPlastic,
            "amountOfPaper": amountOfPaper,
            "amountOfTextile": amountOfTextile,
            "amountOfEWaste": amountOfEWaste,
            "amountOfBioWaste": amountOfBioWaste,
            "amountOfIron": amountOfIron,
            "uid": uid
        ]
    }
    
}