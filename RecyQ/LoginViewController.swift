//
//  LoginViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase

var user: User?

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var username: String?
    
    var users = [User]()
    
    var userUID: String?
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    let ref = Firebase(url: "https://recyqdb.firebaseio.com/")
    let clientsRef = Firebase(url: "https://recyqdb.firebaseio.com/clients")

    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldLoginEmail.delegate = self
        textFieldLoginPassword.delegate = self
        // Do any additional setup after loading the view.
        // login
        //hello
        
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        if textFieldLoginEmail.text == "" || textFieldLoginPassword.text == "" {
            
            
        } else {
            
        ref.authUser(textFieldLoginEmail.text, password: textFieldLoginPassword.text,
            withCompletionBlock: { (error, auth) in
                
                if (error != nil) {
                    // an error occurred while attempting login
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch (errorCode) {
                        case .UserDoesNotExist:
                            print("Handle invalid user")
                        case .InvalidEmail:
                            print("Handle invalid email")
                        case .InvalidPassword:
                            print("Handle invalid password")
                        default:
                            print("Handle default situation")
                        }}}

                        else {
                            
                        
                self.ref.queryOrderedByChild("uid").queryEqualToValue(auth.uid).observeEventType(.ChildAdded, withBlock: { snapshot in
                    
                    let snapshotName = snapshot.key
                    let name = snapshot.value.objectForKey("name") as? String
                    let addedByUser = snapshot.value.objectForKey("addedByUser") as? String
                    var amountOfPlastic = snapshot.value.objectForKey("amountOfPlastic") as? Double
                    let amountOfBioWaste = snapshot.value.objectForKey("amountOfBioWaste") as? Double
                    let amountOfEWaste = snapshot.value.objectForKey("amountOfEWaste") as? Double
                    let amountOfIron = snapshot.value.objectForKey("amountOfIron") as? Double
                    let amountOfPaper = snapshot.value.objectForKey("amountOfPaper") as? Double
                    let amountOfTextile = snapshot.value.objectForKey("amountOfTextile") as? Double
                    let completed = snapshot.value.objectForKey("completed") as? Bool
                    let uid = snapshot.value.objectForKey("uid") as? String
                    
                    user = User(name: name!, addedByUser: addedByUser!, completed: completed!, amountOfPlastic: amountOfPlastic!, amountOfPaper: amountOfPaper!, amountOfTextile: amountOfTextile!, amountOfEWaste: amountOfEWaste!, amountOfBioWaste: amountOfBioWaste!, amountOfIron: amountOfIron!, uid: uid!)
                    
                    print(user)
                    
                } )
        })
        
       
        
        ref.observeAuthEventWithBlock { (authData) -> Void in
            // 2
            if authData != nil {
                // 3
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = appDelegate.tabbarController
                appDelegate.tabbarController?.selectedIndex = 0
            }
        }
<<<<<<< HEAD
        }}
=======
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.window?.rootViewController = appDelegate.tabbarController
                }})}}
>>>>>>> a5248b5fc27633dd542ca24eee90b5ecbe50a4ae
    
        
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Sign up for a new RecyQ account.", message: "", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction) -> Void in
            let usernameField = alert.textFields![0]
            let emailField = alert.textFields![1]
            let passwordField = alert.textFields![2]
            
            self.ref.createUser(emailField.text, password: passwordField.text) { (error: NSError!) in
            
                if error == nil {
                    
                    self.ref.authUser(emailField.text, password: passwordField.text, withCompletionBlock: { (error, auth) in
                        
                         user = User(name: usernameField.text!.lowercaseString, addedByUser: emailField.text!, completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: auth.uid)
                        
                        let userRef = self.clientsRef.childByAppendingPath(user!.name)
                        userRef.setValue(user!.toAnyObject())
                        
                        if let newUserName = user!.name {
                            self.username = newUserName
                            print(self.username)
                            
                        }
                        
                        self.userUID = auth.uid
                        print(self.userUID)
                        print(user?.uid)
                        print("WOOHOO \(self.ref.queryEqualToValue(user?.uid))")
                    })

                    
                    print(user)
                    print("hello \(user)")
                    
                }
            }

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler { (textUsername) -> Void in
            textUsername.placeholder = "Enter your username"
        }
        
        alert.addTextFieldWithConfigurationHandler { (textEmail) -> Void in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextFieldWithConfigurationHandler { (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
