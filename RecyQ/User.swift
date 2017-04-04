//
//  User.swift
//  RecyQ
//
//  Created by Jim Petri on 22/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import Foundation
import Firebase

// Todo: Update code by putting the snaphot init inside an extension of User. Than we can use the memberwise init of the struct in stead of the created init.

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
    let uid: String!
    let spentCoins: Int!
    
    // Initialize from arbitrary data
    init(name: String, addedByUser: String, completed: Bool, key: String = "",  amountOfPlastic: Double, amountOfPaper: Double, amountOfTextile: Double, amountOfEWaste: Double, amountOfBioWaste: Double, uid: String, spentCoins: Int) {
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
        self.uid = uid
        self.spentCoins = spentCoins
    }
//}
//    extension User {
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
        uid = snapshotValue?["uid"] as? String
        spentCoins = snapshotValue?["uid"] as? Int
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return [
            "name": name as AnyObject,
            "addedByUser": addedByUser as AnyObject,
            "completed": completed as AnyObject,
            "amountOfPlastic": amountOfPlastic as AnyObject,
            "amountOfPaper": amountOfPaper as AnyObject,
            "amountOfTextile": amountOfTextile as AnyObject,
            "amountOfEWaste": amountOfEWaste as AnyObject,
            "amountOfBioWaste": amountOfBioWaste as AnyObject,
            "uid": uid as AnyObject,
            "spentCoins": spentCoins as AnyObject
        ]
    }
    
}
