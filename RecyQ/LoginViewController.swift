//
//  LoginViewController.swift
//  RecyQ
//
//  Created by Jim Petri on 21/03/16.
//  Copyright © 2016 Jimsalabim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

var currentUser: User?

var reachability: Reachability?

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var username: String?
    
    var users = [User]()
    
    var userUID: String?
    
    let ref = FIRDatabase.database().reference()
    let clientsRef = FIRDatabase.database().reference(withPath: "clients")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldLoginEmail.delegate = self
        textFieldLoginPassword.delegate = self
        
        //Hide keyboard #1
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        loginButton.layer.cornerRadius = 5
        
        // Facebook log in button.
        let faceBookLogInButton = FBSDKLoginButton()
        faceBookLogInButton.delegate = self
        faceBookLogInButton.readPermissions = ["email", "public_profile"]
        faceBookLogInButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        view.addSubview(faceBookLogInButton)
        
    }
    
    //hide keyboard #2
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        reachability = Reachability.init()
        
        reachability!.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachableViaWiFi {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        
        reachability!.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                print("Not reachable")
                
                let alert = UIAlertController(title: "Oeps!", message: "Please connect to the internet to use the RecyQ app.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) -> Void in
                }
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        
        do {
            try reachability!.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        
        if textFieldLoginEmail.text == "" || textFieldLoginPassword.text == "" {
            
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!, completion: { (user, error) in
                
                if (error != nil) {
                    // an error occurred while attempting login
                    
                    
                    if let errorCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                        switch (errorCode) {
                        case .errorCodeUserNotFound:
                            print("Handle invalid user")
                            
                            let alertController = UIAlertController(title: "Onjuiste gebruikersnaam", message: "Probeer het opnieuw.", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                            }
                            
                            alertController.addAction(okAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                        case .errorCodeInvalidEmail:
                            print("Handle invalid email")
                            
                            let alertController = UIAlertController(title: "Onjuist e-mailadres", message: "Probeer het opnieuw.", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                            }
                            
                            alertController.addAction(okAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                        case .errorCodeWrongPassword:
                            print("Handle invalid password")
                            
                            let alertController = UIAlertController(title: "Wachtwoord is onjuist", message: "Probeer het opnieuw.", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                            }
                            
                            alertController.addAction(okAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                        default:
                            print("Handle default situation")
                            let alertController = UIAlertController(title: "Oeps!", message: "Something went wrong. Please check your internet connection & try again.", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                            }
                            alertController.addAction(okAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }}}
                else {
                    
                    self.ref.queryOrdered(byChild: "uid").queryEqual(toValue: user?.uid).observe(.childAdded, with: { snapshot in
                        
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
                    
                    FIRAuth.auth()!.addStateDidChangeListener({ (auth, user) in
                        if let user = user {
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.window?.rootViewController = appDelegate.tabbarController
                            appDelegate.tabbarController?.selectedIndex = 0
                        }
                    })
                    
//                    self.ref.observeAuthEvent { (authData) -> Void in
//                        // 2
//                        if authData != nil {
//                            // 3
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            appDelegate.window?.rootViewController = appDelegate.tabbarController
//                            appDelegate.tabbarController?.selectedIndex = 0
//                        }
//                    }
                    
                }
                
            })
        }
    }
    
//            ref.authUser(textFieldLoginEmail.text, password: textFieldLoginPassword.text,
//                         withCompletionBlock: { (error, auth) in
//                            
//                            if (error != nil) {
//                                // an error occurred while attempting login
//                                if let errorCode = FAuthenticationError(rawValue: (error?._code)!) {
//                                    switch (errorCode) {
//                                    case .userDoesNotExist:
//                                        print("Handle invalid user")
//                                        
//                                        let alertController = UIAlertController(title: "Onjuiste gebruikersnaam", message: "Probeer het opnieuw.", preferredStyle: .alert)
//                                        
//                                        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
//                                        }
//                                        
//                                        alertController.addAction(okAction)
//                                        
//                                        self.present(alertController, animated: true, completion: nil)
//                                        
//                                    case .invalidEmail:
//                                        print("Handle invalid email")
//                                        
//                                        let alertController = UIAlertController(title: "Onjuist e-mailadres", message: "Probeer het opnieuw.", preferredStyle: .alert)
//                                        
//                                        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
//                                        }
//                                        
//                                        alertController.addAction(okAction)
//                                        
//                                        self.present(alertController, animated: true, completion: nil)
//                                        
//                                    case .invalidPassword:
//                                        print("Handle invalid password")
//                                        
//                                        let alertController = UIAlertController(title: "Wachtwoord is onjuist", message: "Probeer het opnieuw.", preferredStyle: .alert)
//                                        
//                                        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
//                                        }
//                                        
//                                        alertController.addAction(okAction)
//                                        
//                                        self.present(alertController, animated: true, completion: nil)
//                                        
//                                    default:
//                                        print("Handle default situation")
//                                        let alertController = UIAlertController(title: "Oeps!", message: "Something went wrong. Please check your internet connection & try again.", preferredStyle: .alert)
//                                        
//                                        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
//                                        }
//                                        alertController.addAction(okAction)
//                                        
//                                        self.present(alertController, animated: true, completion: nil)
//                                    }}}
//                                
//                            else {
//                                
//                                
//                                self.ref?.queryOrdered(byChild: "uid").queryEqual(toValue: auth?.uid).observe(.childAdded, with: { snapshot in
//                                    
//                                    //let snapshotName = snapshot.key
//                                    let name = (snapshot?.value as AnyObject).object(forKey: "name") as? String
//                                    let addedByUser = (snapshot?.value as AnyObject).object(forKey: "addedByUser") as? String
//                                    let amountOfPlastic = (snapshot?.value as AnyObject).object(forKey: "amountOfPlastic") as? Double
//                                    let amountOfBioWaste = (snapshot?.value as AnyObject).object(forKey: "amountOfBioWaste") as? Double
//                                    let amountOfEWaste = (snapshot?.value as AnyObject).object(forKey: "amountOfEWaste") as? Double
//                                    let amountOfIron = (snapshot?.value as AnyObject).object(forKey: "amountOfIron") as? Double
//                                    let amountOfPaper = (snapshot?.value as AnyObject).object(forKey: "amountOfPaper") as? Double
//                                    let amountOfTextile = (snapshot?.value as AnyObject).object(forKey: "amountOfTextile") as? Double
//                                    let completed = (snapshot?.value as AnyObject).object(forKey: "completed") as? Bool
//                                    let uid = (snapshot?.value as AnyObject).object(forKey: "uid") as? String
//                                    let spentCoins = (snapshot?.value as AnyObject).object(forKey: "spentCoins") as? Int
//                                    
//                                    user = User(name: name!, addedByUser: addedByUser!, completed: completed!, amountOfPlastic: amountOfPlastic!, amountOfPaper: amountOfPaper!, amountOfTextile: amountOfTextile!, amountOfEWaste: amountOfEWaste!, amountOfBioWaste: amountOfBioWaste!, amountOfIron: amountOfIron!, uid: uid!, spentCoins: spentCoins!)
//                                    
//                                    print(user)
//                                    
//                                })
//                                
//                                self.ref?.observeAuthEvent { (authData) -> Void in
//                                    // 2
//                                    if authData != nil {
//                                        // 3
//                                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                                        appDelegate.window?.rootViewController = appDelegate.tabbarController
//                                        appDelegate.tabbarController?.selectedIndex = 0
//                                    }
//                                }
//                                //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                                //        appDelegate.window?.rootViewController = appDelegate.tabbarController
//                            }})}}
//    
    
    
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Maak een nieuwe RecyQ account.", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Opslaan", style: .default) { (action: UIAlertAction) -> Void in
            let usernameField = alert.textFields![0]
            let emailField = alert.textFields![1]
            let passwordField = alert.textFields![2]
            
            if let email = emailField.text, let password = passwordField.text {
                
                
                
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                    
                    if error != nil {
                        print("Error signing user in: \(error?.localizedDescription)")
                        return
                    }
                    else {
                        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                print("Error signing user in: \(error?.localizedDescription)")
                                return
                            }
                            else {
                                 currentUser = User(name: usernameField.text!.lowercased(), addedByUser: emailField.text!, completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: (user?.uid)!, spentCoins: 0)
                                
                                let userRef = self.clientsRef.child(byAppendingPath: (currentUser?.name)!)
                                userRef.setValue(currentUser?.toAnyObject())
                                
                                if let newUserName = currentUser?.name {
                                    self.username = newUserName
                                    print(self.username as Any)
                                    
                                }
                            
                                self.userUID = user?.uid
                                print(self.userUID)
                                print(user?.uid)
                                print("WOOHOO \(self.ref.queryEqual(toValue: user?.uid))")
                            }
                        })
                    }
                    
                })
                
            }
            
            
            //            self.ref.createUser(emailField.text, password: passwordField.text, withCompletionBlock: { (error) in
            //
            //                if error == nil {
            //
            //                    self.ref?.authUser(emailField.text, password: passwordField.text, withCompletionBlock: { (error, auth) in
            //
            //                        user = User(name: usernameField.text!.lowercased(), addedByUser: emailField.text!, completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: (auth?.uid)!, spentCoins: 0)
            //
            //                        let userRef = self.clientsRef?.child(byAppendingPath: user!.name)
            //                        userRef?.setValue(user!.toAnyObject())
            //
            //                        if let newUserName = user!.name {
            //                            self.username = newUserName
            //                            print(self.username as Any)
            //
            //                        }
            //
            //                        self.userUID = auth?.uid
            //                        print(self.userUID)
            //                        print(user?.uid)
            //                        print("WOOHOO \(self.ref?.queryEqual(toValue: user?.uid))")
            //                    })
            //
            //
            //                    print(user)
            //                    print("hello \(user)")
            //
            //                }
            //            })
            
        }
        
        let cancelAction = UIAlertAction(title: "Annuleer", style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextField { (textUsername) -> Void in
            textUsername.placeholder = "Gebruikersnaam"
        }
        
        alert.addTextField { (textEmail) -> Void in
            textEmail.placeholder = "E-mailadres"
        }
        
        alert.addTextField { (textPassword) -> Void in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Wachtwoord"
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Hide keyboard #3
    func keyboardWillHide(_ sender: Notification) {
        let userInfo: [AnyHashable: Any] = sender.userInfo!
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    //Hide keyboard #4
    func keyboardWillShow(_ sender: Notification) {
        let userInfo: [AnyHashable: Any] = sender.userInfo!
        
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        let offset: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            if self.view.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
        print(self.view.frame.origin.y)
    }
    
    @IBAction func wachtwoordVergetenButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Wachtwoord vergeten?", message: "Voer uw e-mailadres in. U ontvangt hierop een nieuw wachtwoord", preferredStyle: .alert)
        
        alert.addTextField { (textEmail) -> Void in
            textEmail.placeholder = "Voer uw e-mailadres in"
        }
        
        let resetPasswordAction = UIAlertAction(title: "Reset wachtwoord", style: .default) { (action: UIAlertAction) -> Void in
            
            let usernameField = alert.textFields![0]
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: usernameField.text!, completion: { (error) in
                if error != nil {
                    
                    let errorAlert = UIAlertController(title: "Oeps!", message: "U heeft geen geldig e-mailadres ingevuld. Probeer het nogmaals.", preferredStyle: .alert)
                    
                    let terugAction = UIAlertAction(title: "Terug", style: .default) { (action: UIAlertAction) -> Void in
                    }
                    
                    errorAlert.addAction(terugAction)
                    self.present(errorAlert, animated: true, completion: nil)
                    
                    print("There was an error processing the request")
                }
                else {
                    
                    print("password reset sent")
                    
                    let successAlert = UIAlertController(title: "Wachtwoord verstuurd!", message: "U ontvangt een nieuw wachtwoord op het door u opgegeven e-mailadres.", preferredStyle: .alert)
                    
                    let okayAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) -> Void in
                    }
                    
                    successAlert.addAction(okayAction)
                    self.present(successAlert, animated: true, completion: nil)
                    
                    // Password reset sent successfully
                }
                
                
                
            })
            
            //            self.ref.resetPassword(forUser: usernameField.text, withCompletionBlock: { error in
            //                if error != nil {
            //
            //                    let errorAlert = UIAlertController(title: "Oeps!", message: "U heeft geen geldig e-mailadres ingevuld. Probeer het nogmaals.", preferredStyle: .alert)
            //
            //                    let terugAction = UIAlertAction(title: "Terug", style: .default) { (action: UIAlertAction) -> Void in
            //                    }
            //
            //                    errorAlert.addAction(terugAction)
            //                    self.present(errorAlert, animated: true, completion: nil)
            //
            //                  print("There was an error processing the request")
            //                } else {
            //                    print("password reset sent")
            //
            //                    let successAlert = UIAlertController(title: "Wachtwoord verstuurd!", message: "U ontvangt een nieuw wachtwoord op het door u opgegeven e-mailadres.", preferredStyle: .alert)
            //                    
            //                    let okayAction = UIAlertAction(title: "Ok", style: .default) { (action: UIAlertAction) -> Void in
            //                    }
            //                    
            //                    successAlert.addAction(okayAction)
            //                    self.present(successAlert, animated: true, completion: nil)
            //                    
            //                    // Password reset sent successfully
            //                }
            //            })
            
        }
        
        let cancelAction = UIAlertAction(title: "Annuleer", style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addAction(resetPasswordAction)
        
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print("Error loggin in to facebook \(error)")
            return
        }
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, err) in
            print("Result is :\(result)")
            
        }
    
        print("Successfully logged in to facebook \(result)")
        self.addFacebookUserToFireBase()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did logout from facebook")
    }
    
    func addFacebookUserToFireBase() {
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else {
            return
        }
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil {
                print("Something went wrong with FB user login:", error)
            }
            else {
                print("FB user logged in suceccfully:", user)
                
                //                self.ref.queryOrdered(byChild: "uid").queryEqual(toValue: user?.uid).observe(.childAdded, with: { snapshot in
                //
                //                    //let snapshotName = snapshot.key
                //                    let name = (snapshot.value as AnyObject).object(forKey: "name") as? String
                //                    let addedByUser = (snapshot.value as AnyObject).object(forKey: "addedByUser") as? String
                //                    let amountOfPlastic = (snapshot.value as AnyObject).object(forKey: "amountOfPlastic") as? Double
                //                    let amountOfBioWaste = (snapshot.value as AnyObject).object(forKey: "amountOfBioWaste") as? Double
                //                    let amountOfEWaste = (snapshot.value as AnyObject).object(forKey: "amountOfEWaste") as? Double
                //                    let amountOfIron = (snapshot.value as AnyObject).object(forKey: "amountOfIron") as? Double
                //                    let amountOfPaper = (snapshot.value as AnyObject).object(forKey: "amountOfPaper") as? Double
                //                    let amountOfTextile = (snapshot.value as AnyObject).object(forKey: "amountOfTextile") as? Double
                //                    let completed = (snapshot.value as AnyObject).object(forKey: "completed") as? Bool
                //                    let uid = (snapshot.value as AnyObject).object(forKey: "uid") as? String
                //                    let spentCoins = (snapshot.value as AnyObject).object(forKey: "spentCoins") as? Int
                //
                //                    let currentUser = User(name: name!, addedByUser: addedByUser!, completed: completed!, amountOfPlastic: amountOfPlastic!, amountOfPaper: amountOfPaper!, amountOfTextile: amountOfTextile!, amountOfEWaste: amountOfEWaste!, amountOfBioWaste: amountOfBioWaste!, amountOfIron: amountOfIron!, uid: uid!, spentCoins: spentCoins!)
                //
                //                    print(currentUser)
                //
                //                })
                
                if let fbCurrentUser = user {
                    currentUser = User(name: (fbCurrentUser.displayName?.lowercased())!, addedByUser: (fbCurrentUser.email)!, completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: (user?.uid)!, spentCoins: 0)
                    
                    let userRef = self.clientsRef.child((currentUser?.name)!)
                    //                    let userRef = self.clientsRef.child(byAppendingPath: facebookUser.name)
                    userRef.setValue(currentUser?.toAnyObject())
                    
                    if let newUserName = currentUser?.name {
                        self.username = newUserName
                        print(self.username as Any)
                        
                    }
                    self.userUID = currentUser?.uid
                }
                
            }
        })
        
    }
}
