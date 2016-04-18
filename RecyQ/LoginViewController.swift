//
//  LoginViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    let ref = Firebase(url: "https://recyqdb.firebaseio.com/")

    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldLoginEmail.delegate = self
        textFieldLoginPassword.delegate = self
        // Do any additional setup after loading the view.
        // login
        //hello
        
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        ref.authUser(textFieldLoginEmail.text, password: textFieldLoginPassword.text,
            withCompletionBlock: { (error, auth) in
                

        })
        
        ref.observeAuthEventWithBlock { (authData) -> Void in
            // 2
            if authData != nil {
                // 3
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = appDelegate.tabbarController
            }
        }
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.window?.rootViewController = appDelegate.tabbarController
    }
    
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Sign up for a new RecyQ account.", message: "", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action: UIAlertAction) -> Void in
            let emailField = alert.textFields![0]
            let passwordField = alert.textFields![1]
            
            self.ref.createUser(emailField.text, password: passwordField.text) { (error: NSError!) in
                
                if error == nil {
                    
                    self.ref.authUser(emailField.text, password: passwordField.text, withCompletionBlock: { (error, auth) in
                        
                    })
                }
            }

        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action: UIAlertAction) -> Void in
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
