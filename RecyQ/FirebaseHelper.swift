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
    
    // MARK: - Firebase references
    struct References {
        static let ref = FIRDatabase.database().reference()
        static let clientsRef = FIRDatabase.database().reference(withPath: "clients")
        static let couponsRef = FIRDatabase.database().reference(withPath: "coupons")
    }
    
    // MARK: - Sign up user through Firebase
    static func signUpUserWith(userName: String, email: String, password: String, sender: UIViewController) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                    showAlertForSpecific(errorCode: errorCode, sender: sender)
                }
                print("Error signing new user in: \(error?.localizedDescription)")
                return
            }
            else {
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    
                    if error != nil {
                        if let errorCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                            showAlertForSpecific(errorCode: errorCode, sender: sender)
                        }
                        print("Error logging user in: \(error?.localizedDescription)")
                        return
                    }
                    else {
                        currentUser = User(name: userName.lowercased(), addedByUser: email, completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, uid: (user?.uid)!, spentCoins: 0)
                        
                        let userRef = FirebaseHelper.References.clientsRef.child((currentUser?.name)!)
                        userRef.setValue(currentUser?.toAnyObject())
                        
//                        if let newUserName = currentUser?.name {
//                            self.username = newUserName
//                            print(self.username as Any)
//                            
//                        }
//                        self.userUID = user?.uid
//                        print("User id is: \(self.userUID)")
//                        print(user?.uid)
//                        print("WOOHOO \(FirebaseHelper.References.ref.queryEqual(toValue: user?.uid))")
                    }
                })
            }
        })
    }
    
    //MARK: - Log user in through Firebase
    static func logUserInWith(email: String, password: String, sender: UIViewController) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                    showAlertForSpecific(errorCode: errorCode, sender: sender)
                }
                return
            }
            else {
                if let user = user {
                    queryOrderedBy(child: "uid", value: user.uid, completionHandler: { (user) in
                        observeAuthentication()
                    })
                }
            }
        })
    }
    
    //MARK: - Send password reset request to Firebase
    static func sendRequestForPasswordResetWith(email: String, sender: UIViewController) {
        
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error != nil {
                sender.showAlertWith(title: "Oeps!", message: "U heeft geen geldig e-mailadres ingevuld. Probeer het nogmaals.")
                print("There was an error processing the reset password request")
            }
            else {
                
                sender.showAlertWith(title: "Wachtwoord verstuurd!", message: "U ontvangt een nieuw wachtwoord op het door u opgegeven e-mailadres.")
                print("password reset sent")
            }
        })
    }
    
    //MARK: - Authenticate FirebaseUser
    static func observeAuthentication() {
        FIRAuth.auth()!.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                Constants.appDelegate.window?.rootViewController = Constants.appDelegate.tabbarController
                Constants.appDelegate.tabbarController?.selectedIndex = 0
            }
            else {
                let loginViewController = LoginViewController()
                Constants.appDelegate.window?.rootViewController = loginViewController
            }
        })
    }
    
    //MARK: - Alerts for errorhandeling
    private static func showAlertForSpecific(errorCode: FIRAuthErrorCode, sender: UIViewController) {
        
        switch (errorCode) {
            
        case .errorCodeUserNotFound:
            print("Handle invalid user")
            sender.showAlertWith(title: "Onjuiste gebruikersnaam", message: "Probeer het opnieuw.")
            
        case .errorCodeInvalidEmail:
            print("Handle invalid email")
            sender.showAlertWith(title: "Onjuist e-mailadres", message: "Probeer het opnieuw.")
            
        case .errorCodeWrongPassword:
            print("Handle invalid password")
            sender.showAlertWith(title: "Wachtwoord is onjuist", message: "Probeer het opnieuw.")
            
        default:
            print("Handle default situation")
            sender.showAlertWith(title: "Oeps!", message: "Something went wrong. Please check your internet connection & try again.")
        }
    }
    
    //MARK: - Query the Firebase database
    static func queryOrderedBy(child: String, value: String, completionHandler: @escaping (User) -> ()) {
        
        References.clientsRef.queryOrdered(byChild: child).queryEqual(toValue: value).observe(.childAdded, with: { snapshot in
            //let snapshotName = snapshot.key
//            let name = (snapshot.value as AnyObject).object(forKey: "name") as? String
//            let addedByUser = (snapshot.value as AnyObject).object(forKey: "addedByUser") as? String
//            let amountOfPlastic = (snapshot.value as AnyObject).object(forKey: "amountOfPlastic") as? Double
//            let amountOfBioWaste = (snapshot.value as AnyObject).object(forKey: "amountOfBioWaste") as? Double
//            let amountOfEWaste = (snapshot.value as AnyObject).object(forKey: "amountOfEWaste") as? Double
//            let amountOfIron = (snapshot.value as AnyObject).object(forKey: "amountOfIron") as? Double
//            let amountOfPaper = (snapshot.value as AnyObject).object(forKey: "amountOfPaper") as? Double
//            let amountOfTextile = (snapshot.value as AnyObject).object(forKey: "amountOfTextile") as? Double
//            let completed = (snapshot.value as AnyObject).object(forKey: "completed") as? Bool
//            let uid = (snapshot.value as AnyObject).object(forKey: "uid") as? String
//            let spentCoins = (snapshot.value as AnyObject).object(forKey: "spentCoins") as? Int
            
            currentUser = User(snapshot: snapshot)
            if currentUser != nil {
            completionHandler(currentUser!)
            }
//            currentUser = User(name: name!, addedByUser: addedByUser!, completed: completed!, amountOfPlastic: amountOfPlastic!, amountOfPaper: amountOfPaper!, amountOfTextile: amountOfTextile!, amountOfEWaste: amountOfEWaste!, amountOfBioWaste: amountOfBioWaste!, amountOfIron: amountOfIron!, uid: uid!, spentCoins: spentCoins!)
            
            print("Current user is: \(currentUser)")
        })
    }
}
