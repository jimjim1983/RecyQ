//
//  FirebaseHelper.swift
//  RecyQ
//
//  Created by Supervisor on 21-02-17.
//  Copyright © 2017 Jimsalabim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

struct FirebaseHelper {
    struct References {
        static let ref = FIRDatabase.database().reference()
        static let clientsRef = FIRDatabase.database().reference(withPath: "clients")
    }
    
    static func logUserInWith(email: String, password: String, viewController: UIViewController) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                // an error occurred while attempting login
                
                if let errorCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                    
                    showAlertForSpecific(errorCode: errorCode, viewController: viewController)
                    
                }
            }
            else {
                if let user = user {
                    queryOrderedBy(child: "uid", value: user.uid)
                    authenticateUser()
                }
            }
        })
    }
    
    static func sendRequestForPasswordResetWith(email: String, viewController: UIViewController) {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error != nil {
                
                viewController.showAlertWith(title: "Oeps!", message: "U heeft geen geldig e-mailadres ingevuld. Probeer het nogmaals.")
                print("There was an error processing the reset password request")
            }
            else {
                
                viewController.showAlertWith(title: "Wachtwoord verstuurd!", message: "U ontvangt een nieuw wachtwoord op het door u opgegeven e-mailadres.")
                print("password reset sent")
            }
        })
    }
    
    static func authenticateUser() {
        FIRAuth.auth()!.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                Constants.appDelegate.window?.rootViewController = Constants.appDelegate.tabbarController
                Constants.appDelegate.tabbarController?.selectedIndex = 0
            }
        })
    }
    
    private static func showAlertForSpecific(errorCode: FIRAuthErrorCode, viewController: UIViewController) {
        
        switch (errorCode) {
            
        case .errorCodeUserNotFound:
            print("Handle invalid user")
            viewController.showAlertWith(title: "Onjuiste gebruikersnaam", message: "Probeer het opnieuw.")
            
        case .errorCodeInvalidEmail:
            print("Handle invalid email")
            viewController.showAlertWith(title: "Onjuist e-mailadres", message: "Probeer het opnieuw.")
            
        case .errorCodeWrongPassword:
            print("Handle invalid password")
            viewController.showAlertWith(title: "Wachtwoord is onjuist", message: "Probeer het opnieuw.")
            
        default:
            print("Handle default situation")
            viewController.showAlertWith(title: "Oeps!", message: "Something went wrong. Please check your internet connection & try again.")
        }
    }
    
    private static func queryOrderedBy(child: String, value: String) {
        
        References.ref.queryOrdered(byChild: child).queryEqual(toValue: value).observe(.childAdded, with: { snapshot in
            //let snapshotName = snapshot.key
            let name = (snapshot.value as AnyObject).object(forKey: "name") as? String
            let addedByUser = (snapshot.value as AnyObject).object(forKey: "addedByUser") as? String
            let amountOfPlastic = (snapshot.value as AnyObject).object(forKey: "amountOfPlastic") as? Double
            let amountOfBioWaste = (snapshot.value as AnyObject).object(forKey: "amountOfBioWaste") as? Double
            let amountOfEWaste = (snapshot.value as AnyObject).object(forKey: "amountOfEWaste") as? Double
            let amountOfIron = (snapshot.value as AnyObject).object(forKey: "amountOfIron") as? Double
            let amountOfPaper = (snapshot.value as AnyObject).object(forKey: "amountOfPaper") as? Double
            let amountOfTextile = (snapshot.value as AnyObject).object(forKey: "amountOfTextile") as? Double
            let completed = (snapshot.value as AnyObject).object(forKey: "completed") as? Bool
            let uid = (snapshot.value as AnyObject).object(forKey: "uid") as? String
            let spentCoins = (snapshot.value as AnyObject).object(forKey: "spentCoins") as? Int
            
            currentUser = User(name: name!, addedByUser: addedByUser!, completed: completed!, amountOfPlastic: amountOfPlastic!, amountOfPaper: amountOfPaper!, amountOfTextile: amountOfTextile!, amountOfEWaste: amountOfEWaste!, amountOfBioWaste: amountOfBioWaste!, amountOfIron: amountOfIron!, uid: uid!, spentCoins: spentCoins!)
            
            print(currentUser)
        })
    }
}
