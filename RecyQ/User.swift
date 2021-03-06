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
    var dateCreated: String?
    let key: String
    let name: String
    var lastName: String?
    var address: String?
    var zipCode: String?
    var city: String?
    var phoneNumber: String?
    let addedByUser: String //email
    var nearestWasteLocation: String?
    var registeredVia = "iOS App"
    var didReceiveRecyQBags: Bool?
    let ref: FIRDatabaseReference?
    var completed: Bool
    let amountOfPlastic: Double
    let amountOfPaper: Double
    let amountOfTextile: Double
    let amountOfEWaste: Double
    let amountOfBioWaste: Double
    let amountOfGlass: Double?
    var wasteDepositInfo: [String: Any]?
    let uid: String
    let spentCoins: Int?
    
    // Initialize from arbitrary data
    init(dateCreated: String?, name: String, lastName: String, address: String, zipCode: String, city: String, phoneNumber: String, addedByUser: String, nearestWasteLocation: String, didReceiveRecyQBags: Bool?, completed: Bool, key: String = "",  amountOfPlastic: Double, amountOfPaper: Double, amountOfTextile: Double, amountOfEWaste: Double, amountOfBioWaste: Double, amountOfGlass: Double?, wasteDepositInfo: [String: Any]?, uid: String, spentCoins: Int?) {
        self.dateCreated = dateCreated
        self.key = key
        self.name = name
        self.lastName = lastName
        self.address = address
        self.zipCode = zipCode
        self.city = city
        self.phoneNumber = phoneNumber
        self.addedByUser = addedByUser
        self.nearestWasteLocation = nearestWasteLocation
        self.didReceiveRecyQBags = didReceiveRecyQBags
        self.completed = completed
        self.ref = nil
        self.amountOfPlastic = amountOfPlastic
        self.amountOfPaper = amountOfPaper
        self.amountOfTextile = amountOfTextile
        self.amountOfEWaste = amountOfEWaste
        self.amountOfBioWaste = amountOfBioWaste
        self.amountOfGlass = amountOfGlass
        self.wasteDepositInfo = wasteDepositInfo
        self.uid = uid
        self.spentCoins = spentCoins
    }
//}
//    extension User {
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as? NSDictionary
        dateCreated = snapshotValue?["dateCreated"] as? String
        name = snapshotValue?["name"] as! String
        lastName = snapshotValue?["lastName"] as? String
        address = snapshotValue?["address"] as? String
        zipCode = snapshotValue?["zipCode"] as? String
        city = snapshotValue?["city"] as? String
        phoneNumber = snapshotValue?["phoneNumber"] as? String
        addedByUser = snapshotValue?["addedByUser"] as! String
        nearestWasteLocation = snapshotValue?["nearestWasteLocation"] as? String
        registeredVia = snapshotValue?["registeredVia"] as! String
        didReceiveRecyQBags = snapshotValue?["didReceiveRecyQBags"] as? Bool
        completed = snapshotValue?["completed"] as! Bool
        ref = snapshot.ref
        amountOfPlastic = snapshotValue?["amountOfPlastic"] as! Double
        amountOfPaper = snapshotValue?["amountOfPaper"] as! Double
        amountOfTextile = snapshotValue?["amountOfTextile"] as! Double
        amountOfEWaste = snapshotValue?["amountOfEWaste"] as! Double
        amountOfBioWaste = snapshotValue?["amountOfBioWaste"] as! Double
        amountOfGlass = snapshotValue?["amountOfGlass"] as? Double
        wasteDepositInfo = snapshotValue?["wasteDepositInfo"] as? [String: Any]
        uid = snapshotValue?["uid"] as! String
        spentCoins = snapshotValue?["spentCoins"] as? Int
    }
    
    func toAnyObject() -> [String: AnyObject] {
        return [
            "dateCreated" : dateCreated as AnyObject,
            "name": name as AnyObject,
            "lastName": lastName as AnyObject,
            "address": address as AnyObject,
            "zipCode": zipCode as AnyObject,
            "city": city as AnyObject,
            "phoneNumber": phoneNumber as AnyObject,
            "addedByUser": addedByUser as AnyObject,
            "nearestWasteLocation": nearestWasteLocation as AnyObject,
            "registeredVia": registeredVia as AnyObject,
            "didReceiveRecyQBags": didReceiveRecyQBags as AnyObject,
            "completed": completed as AnyObject,
            "amountOfPlastic": amountOfPlastic as AnyObject,
            "amountOfPaper": amountOfPaper as AnyObject,
            "amountOfTextile": amountOfTextile as AnyObject,
            "amountOfEWaste": amountOfEWaste as AnyObject,
            "amountOfBioWaste": amountOfBioWaste as AnyObject,
            "amountOfGlass": amountOfGlass as AnyObject,
            "wasteDepositInfo": wasteDepositInfo as AnyObject,
            "uid": uid as AnyObject,
            "spentCoins": spentCoins as AnyObject
        ]
    }
}
