//
//  User.swift
//  RecyQ
//
//  Created by Jim Petri on 22/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let key: String!
    let name: String!
    let addedByUser: String!
    let ref: FIRDatabaseReference?
    var completed: Bool!
    let amountOfPlastic: Double!
    var amountOfPaper: Double!
    let amountOfTextile: Double!
    let amountOfEWaste: Double!
    let amountOfBioWaste: Double!
    let amountOfIron: Double!
    let uid: String!
    let spentCoins: Int!
    
    // Initialize from arbitrary data
    init(name: String, addedByUser: String, completed: Bool, key: String = "",  amountOfPlastic: Double, amountOfPaper: Double, amountOfTextile: Double, amountOfEWaste: Double, amountOfBioWaste: Double, amountOfIron: Double, uid: String, spentCoins: Int) {
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
        self.spentCoins = spentCoins
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as? NSDictionary
        name = snapshotValue?["name"] as? String
        addedByUser = snapshotValue?["addedByUser"] as? String
        completed = snapshotValue?["completed"] as? Bool
        ref = snapshot.ref
        amountOfPlastic = snapshotValue?["amountOfPlastic"] as? Double
        amountOfPaper = snapshotValue?["amountOfPaper"] as? Double
        amountOfTextile = snapshotValue?["amountOfTextile"] as? Double
        amountOfEWaste = snapshotValue?["amountOfEWaste"] as? Double
        amountOfBioWaste = snapshotValue?["amountOfBioWaste"] as? Double
        amountOfIron = snapshotValue?["amountOfIron"] as? Double
        uid = snapshotValue?["uid"] as? String
        spentCoins = snapshotValue?["uid"] as? Int
    }
    
    func toAnyObject() -> [String: Any] {
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
            "uid": uid,
            "spentCoins": spentCoins
        ]
    }
    
}
