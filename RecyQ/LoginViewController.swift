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

var reachability: Reachability?

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var username: String?
    
    var users = [User]()
    
    var userUID: String?
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let ref = Firebase(url: "https://recyqdb.firebaseio.com/")
    let clientsRef = Firebase(url: "https://recyqdb.firebaseio.com/clients")

    override func viewDidLoad() {
        super.viewDidLoad()

        textFieldLoginEmail.delegate = self
        textFieldLoginPassword.delegate = self
        
        //Hide keyboard #1
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        loginButton.layer.cornerRadius = 5
        
        // Do any additional setup after loading the view.
        // login
        //hello
        
    }
    
    //hide keyboard #2
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        reachability!.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        
        reachability!.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                print("Not reachable")
                
                let alert = UIAlertController(title: "Oeps!", message: "Please connect to the internet to use the RecyQ app.", preferredStyle: .Alert)
                            let okayAction = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction) -> Void in
                            }
                            alert.addAction(okayAction)
                            self.presentViewController(alert, animated: true, completion: nil)

            }
        }
        
        do {
            try reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
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
                                        
                                        let alertController = UIAlertController(title: "Onjuiste gebruikersnaam", message: "Probeer het opnieuw.", preferredStyle: .Alert)
                                        
                                        let okAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                                        }
                                        
                                        alertController.addAction(okAction)
                                        
                                        self.presentViewController(alertController, animated: true, completion: nil)
                                        
                                    case .InvalidEmail:
                                        print("Handle invalid email")
                                        
                                        let alertController = UIAlertController(title: "Onjuist e-mailadres", message: "Probeer het opnieuw.", preferredStyle: .Alert)
                                        
                                        let okAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                                        }
                                        
                                        alertController.addAction(okAction)
                                        
                                        self.presentViewController(alertController, animated: true, completion: nil)
                                        
                                    case .InvalidPassword:
                                        print("Handle invalid password")
                                        
                                        let alertController = UIAlertController(title: "Wachtwoord is onjuist", message: "Probeer het opnieuw.", preferredStyle: .Alert)
                                        
                                        let okAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                                        }
                                        
                                        alertController.addAction(okAction)
                                        
                                        self.presentViewController(alertController, animated: true, completion: nil)
                                        
                                    default:
                                        print("Handle default situation")
                                        let alertController = UIAlertController(title: "Oeps!", message: "Something went wrong. Please check your internet connection & try again.", preferredStyle: .Alert)
                                        
                                        let okAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in
                                        }
                                        alertController.addAction(okAction)
                                        
                                        self.presentViewController(alertController, animated: true, completion: nil)
                                    }}}
                                
                            else {
                                
                                
                                self.ref.queryOrderedByChild("uid").queryEqualToValue(auth.uid).observeEventType(.ChildAdded, withBlock: { snapshot in
                                    
                                    //let snapshotName = snapshot.key
                                    let name = snapshot.value.objectForKey("name") as? String
                                    let addedByUser = snapshot.value.objectForKey("addedByUser") as? String
                                    let amountOfPlastic = snapshot.value.objectForKey("amountOfPlastic") as? Double
                                    let amountOfBioWaste = snapshot.value.objectForKey("amountOfBioWaste") as? Double
                                    let amountOfEWaste = snapshot.value.objectForKey("amountOfEWaste") as? Double
                                    let amountOfIron = snapshot.value.objectForKey("amountOfIron") as? Double
                                    let amountOfPaper = snapshot.value.objectForKey("amountOfPaper") as? Double
                                    let amountOfTextile = snapshot.value.objectForKey("amountOfTextile") as? Double
                                    let completed = snapshot.value.objectForKey("completed") as? Bool
                                    let uid = snapshot.value.objectForKey("uid") as? String
                                    let spentCoins = snapshot.value.objectForKey("spentCoins") as? Int
                                    
                                    user = User(name: name!, addedByUser: addedByUser!, completed: completed!, amountOfPlastic: amountOfPlastic!, amountOfPaper: amountOfPaper!, amountOfTextile: amountOfTextile!, amountOfEWaste: amountOfEWaste!, amountOfBioWaste: amountOfBioWaste!, amountOfIron: amountOfIron!, uid: uid!, spentCoins: spentCoins!)
                                    
                                    print(user)
                                    
                                })
                                
                                self.ref.observeAuthEventWithBlock { (authData) -> Void in
                                    // 2
                                    if authData != nil {
                                        // 3
                                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                        appDelegate.window?.rootViewController = appDelegate.tabbarController
                                        appDelegate.tabbarController?.selectedIndex = 0
                                    }
                                }
                                //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                //        appDelegate.window?.rootViewController = appDelegate.tabbarController
                            }})}}

    
        
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let alert = UIAlertController(title: "Maak een nieuwe RecyQ account.", message: "", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Opslaan", style: .Default) { (action: UIAlertAction) -> Void in
            let usernameField = alert.textFields![0]
            let emailField = alert.textFields![1]
            let passwordField = alert.textFields![2]
            
            self.ref.createUser(emailField.text, password: passwordField.text) { (error: NSError!) in
            
                if error == nil {
                    
                    self.ref.authUser(emailField.text, password: passwordField.text, withCompletionBlock: { (error, auth) in
                        
                        user = User(name: usernameField.text!.lowercaseString, addedByUser: emailField.text!, completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: auth.uid, spentCoins: 0)
                        
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
        
        let cancelAction = UIAlertAction(title: "Annuleer", style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler { (textUsername) -> Void in
            textUsername.placeholder = "Gebruikersnaam"
        }
        
        alert.addTextFieldWithConfigurationHandler { (textEmail) -> Void in
            textEmail.placeholder = "E-mailadres"
        }
        
        alert.addTextFieldWithConfigurationHandler { (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Wachtwoord"
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        
        presentViewController(alert, animated: true, completion: nil)
    
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Hide keyboard #3
    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    //Hide keyboard #4
    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
        print(self.view.frame.origin.y)
    }
    
    @IBAction func wachtwoordVergetenButtonPressed(sender: UIButton) {
        
        let alert = UIAlertController(title: "Wachtwoord vergeten?", message: "Voer uw e-mailadres in. U ontvangt hierop een nieuw wachtwoord", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textEmail) -> Void in
            textEmail.placeholder = "Voer uw e-mailadres in"
        }
        
        let resetPasswordAction = UIAlertAction(title: "Reset wachtwoord", style: .Default) { (action: UIAlertAction) -> Void in
            
            let usernameField = alert.textFields![0]
            
            self.ref.resetPasswordForUser(usernameField.text, withCompletionBlock: { error in
                if error != nil {
                    
                    let errorAlert = UIAlertController(title: "Oeps!", message: "U heeft geen geldig e-mailadres ingevuld. Probeer het nogmaals.", preferredStyle: .Alert)
                    
                    let terugAction = UIAlertAction(title: "Terug", style: .Default) { (action: UIAlertAction) -> Void in
                    }
                    
                    errorAlert.addAction(terugAction)
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                    
                  print("There was an error processing the request")
                } else {
                    print("password reset sent")
                    
                    let successAlert = UIAlertController(title: "Wachtwoord verstuurd!", message: "U ontvangt een nieuw wachtwoord op het door u opgegeven e-mailadres.", preferredStyle: .Alert)
                    
                    let okayAction = UIAlertAction(title: "Ok", style: .Default) { (action: UIAlertAction) -> Void in
                    }
                    
                    successAlert.addAction(okayAction)
                    self.presentViewController(successAlert, animated: true, completion: nil)
                    
                    // Password reset sent successfully
                }
            })
            
        }
        
            let cancelAction = UIAlertAction(title: "Annuleer", style: .Default) { (action: UIAlertAction) -> Void in
            }
        
        alert.addAction(resetPasswordAction)
        
        alert.addAction(cancelAction)
       
        presentViewController(alert, animated: true, completion: nil)
        
    }
    

}
