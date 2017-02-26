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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addKeyboardNotificationObserver()
        
        textFieldLoginEmail.delegate = self
        textFieldLoginPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Check if there's an internet connection
        ReachabilityHelper.checkReachability(viewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotificationObserver()
    }
    
    func setupViews() {
        loginButton.layer.cornerRadius = 5
        
        // Facebook log in button.
        let faceBookLogInButton = FBSDKLoginButton()
        faceBookLogInButton.delegate = self
        faceBookLogInButton.readPermissions = ["email", "public_profile"]
        faceBookLogInButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        view.addSubview(faceBookLogInButton)
    }
    
    func addKeyboardNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    // Keyboard will hide
    func keyboardWillHide(_ sender: Notification) {
        let userInfo: [AnyHashable: Any] = sender.userInfo!
        let keyboardSize: CGSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    // Keyboard will show
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
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        
        if textFieldLoginEmail.text == "" || textFieldLoginPassword.text == "" {
            self.showAlertWith(title: "Oeps", message: "Vul je e-mailadres en wachtwoord in.")
            
        } else {
            FirebaseHelper.logUserInWith(email: self.textFieldLoginEmail.text!, password: self.textFieldLoginPassword.text!, viewController: self)
        }
    }
    
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
                                
                                let userRef = FirebaseHelper.References.clientsRef.child(byAppendingPath: (currentUser?.name)!)
                                userRef.setValue(currentUser?.toAnyObject())
                                
                                if let newUserName = currentUser?.name {
                                    self.username = newUserName
                                    print(self.username as Any)
                                    
                                }
                                self.userUID = user?.uid
                                print(self.userUID)
                                print(user?.uid)
                                print("WOOHOO \(FirebaseHelper.References.ref.queryEqual(toValue: user?.uid))")
                            }
                        })
                    }
                })
            }
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
    
    @IBAction func wachtwoordVergetenButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Wachtwoord vergeten?", message: "Voer uw e-mailadres in. U ontvangt hierop een nieuw wachtwoord", preferredStyle: .alert)
        
        alert.addTextField { (textEmail) -> Void in
            textEmail.placeholder = "Voer uw e-mailadres in"
        }
        
        let resetPasswordAction = UIAlertAction(title: "Reset wachtwoord", style: .default) { (action: UIAlertAction) -> Void in
            
            let userEmailField = alert.textFields![0]
            
            FirebaseHelper.sendRequestForPasswordResetWith(email: userEmailField.text!, viewController: self)
        }
        
        let cancelAction = UIAlertAction(title: "Annuleer", style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addAction(resetPasswordAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Facebook login delegate methods
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
        FIRAuth.auth()!.addStateDidChangeListener({ (auth, user) in
            if user != nil {
                Constants.appDelegate.window?.rootViewController = Constants.appDelegate.tabbarController
                Constants.appDelegate.tabbarController?.selectedIndex = 0
            }
        })
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
                
                if let fbCurrentUser = user {
                    currentUser = User(name: (fbCurrentUser.displayName?.lowercased())!, addedByUser: (fbCurrentUser.email)!, completed: false, amountOfPlastic: 0, amountOfPaper: 0, amountOfTextile: 0, amountOfEWaste: 0, amountOfBioWaste: 0, amountOfIron: 0, uid: (user?.uid)!, spentCoins: 0)
                    
                    let userRef = FirebaseHelper.References.clientsRef.child((currentUser?.name)!)
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

extension UIViewController {
    func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
