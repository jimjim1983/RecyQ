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
        static let recyQLocations = FIRDatabase.database().reference(withPath: "RecyQ Locations")
        static let shops = FIRDatabase.database().reference(withPath: "Shops")
    }
    
    // MARK: - Sign up user through Firebase
    static func signUp(newUser: User, withPassword: String, sender: UIViewController) {
        FIRAuth.auth()?.createUser(withEmail: newUser.addedByUser, password: withPassword, completion: { (user, error) in
            
            if error != nil {
                if let errorCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                    showAlertForSpecific(errorCode: errorCode, sender: sender)
                }
                print("Error signing new user in: \(error?.localizedDescription)")
                return
            }
            else {
                FIRAuth.auth()?.signIn(withEmail: newUser.addedByUser, password: withPassword, completion: { (user, error) in
                    
                    if error != nil {
                        if let errorCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                            showAlertForSpecific(errorCode: errorCode, sender: sender)
                        }
                        print("Error logging user in: \(error?.localizedDescription)")
                        return
                    }
                    else {
                        currentUser = User(name: newUser.name.lowercased(), lastName: newUser.lastName!, address: newUser.address!, zipCode: newUser.zipCode!, city: newUser.city!, phoneNumber: newUser.phoneNumber!, addedByUser: newUser.addedByUser, nearestWasteLocation: newUser.nearestWasteLocation!, completed: false, amountOfPlastic: newUser.amountOfPlastic, amountOfPaper: newUser.amountOfPaper, amountOfTextile: newUser.amountOfTextile, amountOfEWaste: newUser.amountOfEWaste, amountOfBioWaste: newUser.amountOfBioWaste,amountOfGlass: newUser.amountOfGlass, wasteDepositInfo: nil, uid: (user?.uid)!, spentCoins: newUser.spentCoins)
                        
                        let userRef = References.clientsRef.child((currentUser?.name)!)
                        userRef.setValue(currentUser?.toAnyObject())
                        
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
                Constants.appDelegate.window?.rootViewController?.checkIfFirstLaunch()
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
            sender.showAlertWith(title: "Oeps!", message: "Of het wachtwoord heeft mider dan 6 karakters, of het emailadres bestaat al")
        }
    }
    
    //MARK: - Query the Firebase database
    static func queryOrderedBy(child: String, value: String, completionHandler: @escaping (User) -> ()) {
        
        References.clientsRef.queryOrdered(byChild: child).queryEqual(toValue: value).observe(.childAdded, with: { snapshot in
        
            currentUser = User(snapshot: snapshot)
            
            if currentUser != nil {
                completionHandler(currentUser!)
            }
            
            print("Current user is: \(currentUser)")
        })
    }
}
